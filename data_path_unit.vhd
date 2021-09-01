------------------------------------------------------
-- Author        : Matthew Breidenbach
-- Design Name   : data_path_unit
-- Module Name   : data_path_unit
-- Architecture  : structural 
-- Project Name  : pdp11_processor
-- Target Devices: Basys3
--
-- Description: The technical "execute unit" of the processor. However 
-- 				PDP11 docs will refer to it as the "Dath Path", since 
--				stages are only referred when referencing control signals.
------------------------------------------------------

library ieee;
use IEEE.STD_LOGIC_1164.ALL;

entity data_path_unit is
	PORT(
		-- TODO: there are signals depentant on byte... this scheme may not work
		RegisterDataIn : IN std_logic_vector(15 downto 0);
		BusDataIn : IN std_logic_vector(15 downto 0);
		STPMDataIn : IN std_logic_vector(15 downto 0);
		
		LatchAControl : IN std_logic;
		RegisterAControlPos : IN std_logic;
		RegisterAControlNeg : IN std_logic;
		BusAControlNeg : IN std_logic;
		
		LatchBControl : IN std_logic;
		STPMControl : IN std_logic;
		-- TODO: i think regBcontrol is actually split among H/L bits, might need to change
		RegisterBControlPos : IN std_logic;
		BusBControlPos : IN std_logic;
		
		RotateUseCenter : IN std_logic;
		RotateUseRight : IN std_logic;
		RotateUseLeft : IN std_logic;
		RotateSwapBytes : IN std_logic;
		
		DataOut : OUT std_logic_vector(15 downto 0);
	);
end entity;

architecture structural of data_path_unit is

	component logic_input is
		PORT(
			DataA : IN std_logic_vector(15 downto 0);
			DataB : IN std_logic_vector(15 downto 0);
			DataC : IN std_logic_vector(15 downto 0);
			GateA : IN std_logic_vector(15 downto 0);
			GateB : IN std_logic_vector(15 downto 0);
			GateC : IN std_logic_vector(15 downto 0);
			Latch : IN std_logic_vector(15 downto 0);
			Ouput : OUT std_logic_vector(15 downto 0)
		);
	end logic_input;
	
	component rotate_and_shift_gate is
		PORT(
			CenterAdderResult : IN std_logic;
			LeftAdderResult : IN std_logic;
			RightAdderResult : IN std_logic;
			OppositeByteAdderResult : IN std_logic;
			ControlUseCenter : IN std_logic;
			ControlUseRight : IN std_logic;
			ControlUseLeft : IN std_logic;
			ControlUseOpposite : IN std_logic;
			Ouput : OUT std_logic
		);
	end rotate_and_shift_gate;
	
	component notN is
		GENERIC (N : INTEGER  := 16); --bit  width
		PORT(
			A : IN  std_logic_vector(N-1  downto  0);
			Y : OUT  std_logic_vector(N-1  downto  0)
		);
	end notN;
	
	component adder_unit is
		GENERIC(N : integer := 16);
		PORT(
			A : IN std_logic_vector(N-1 downto 0);
			B : IN std_logic_vector(N-1 downto 0);
			K6_5Carry : IN std_logic;
			Sum : OUT std_logic_vector(N-1 downto 0);
			K8_2Carry : OUT std_logic
		);
	end adder_unit;
	
	signal inverted_reg_data : std_logic_vector(15 downto 0);
	signal inverted_bus_data : std_logic_vector(15 downto 0);
	signal logic_input_A_ouput : std_logic_vector(15 downto 0);
	signal logic_input_B_ouput : std_logic_vector(15 downto 0);
	signal GND : std_logic := 0;
	signal carry_out : std_logic;
	signal adder_ouput : std_logic_vector(15 downto 0);
	
begin

	not_for_reg : notN
		GENERIC MAP(N => 16);
		PORT MAP(
			A => RegisterDataIn,
			Y => inverted_reg_data
		);
		
	not_for_bus : notN
		GENERIC MAP(N => 16);
		PORT MAP(
			A => BusDataIn,
			Y => inverted_bus_data
		);
	
	-- Follows Figure 1-2 data connections
	logic_input_A : logic_input
		PORT MAP(
			DataA => RegisterDataIn,
			DataB => inverted_reg_data,
			DataC => inverted_bus_data,
			GateA => RegisterAControlPos,
			GateB => RegisterAControlNeg,
			GateC => BusAControlNeg,
			Latch => LatchAControl,
			Ouput => logic_input_A_ouput
		);
	
	-- Follows Figure 1-2 data connections
	logic_input_B : logic_input
		PORT MAP(
			DataA => BusDataIn,
			DataB => RegisterDataIn,
			DataC => STPMDataIn,
			GateA => BusBControlPos,
			GateB => RegisterBControlPos,
			GateC => STPMControl,
			Latch => LatchBControl,
			Ouput => logic_input_B_ouput
		);
	
	the_adder_core : adder_unit
		GENERIC MAP(N => 16);
		PORT MAP(
			A => logic_input_A_ouput,
			B => logic_input_B_ouput,
			K6_5Carry => GND,
			Sum => adder_ouput,
			K8_2Carry => carry_out
		);
	
	rotate0 : rotate_and_shift_gate
		PORT MAP(
			CenterAdderResult => adder_ouput(0),
			LeftAdderResult => adder_ouput(1),
			-- TODO: change to proper signal
			RightAdderResult => GND,
			-- TODO: check if correct connection
			OppositeByteAdderResult => adder_output(15),
			ControlUseCenter => RotateUseCenter,
			ControlUseRight => RotateUseRight,
			ControlUseLeft => RotateUseLeft,
			ControlUseOpposite => RotateSwapBytes,
			Output => DataOut(0)
		);
			
	
	rotate_gen : for i in N-2 downto 1 generate
		the_rotator : rotate_and_shift_gate
		PORT MAP(
			CenterAdderResult => adder_ouput(i),
			LeftAdderResult => adder_ouput(i+1),
			RightAdderResult => adder_ouput(i-1),
			-- TODO: this may be incorrect formatting
			OppositeByteAdderResult => adder_ouput(N-1-i),
			ControlUseCenter => RotateUseCenter,
			ControlUseRight => RotateUseRight,
			ControlUseLeft => RotateUseLeft,
			ControlUseOpposite => RotateSwapBytes,
			Ouput => DataOut(i)
		);
	end generate;
	
	rotate15 : rotate_and_shift_gate
		PORT MAP(
			CenterAdderResult => adder_ouput(15),
			LeftAdderResult => adder_ouput(15),
			-- TODO: change to proper signal
			RightAdderResult => GND,
			-- TODO: check if correct connection
			OppositeByteAdderResult => adder_output(0),
			ControlUseCenter => RotateUseCenter,
			ControlUseRight => RotateUseRight,
			ControlUseLeft => RotateUseLeft,
			ControlUseOpposite => RotateSwapBytes,
			Output => DataOut(15)
		);
end architecture;
			