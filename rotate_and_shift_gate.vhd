------------------------------------------------------
-- Author        : Matthew Breidenbach
-- Design Name   : rotate_and_shift_gate
-- Module Name   : rotate_and_shift_gate
-- Architecture  : structural
-- Project Name  : pdp11_processor
-- Target Devices: Basys3
--
-- Description: Gate designed to be connected for shifting and rotating of bits after exiting the adder.
------------------------------------------------------

-- TODO: check if all libraries are needed
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity rotate_and_shift_gate is
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

architecture structural of rotate_and_shift_gate is
	
	-- TODO: find out of generics need defaults passed down into component instances
	component andN is
		GENERIC (N : INTEGER  := 16);
		PORT(
			A : IN  std_logic_vector(N-1  downto  0);
			B : IN  std_logic_vector(N-1  downto  0);
			Y : OUT  std_logic_vector(N-1  downto  0)
        );
	end andN;
	
	component nor4N is
		GENERIC (N : INTEGER  := 16);
		PORT(
			A : IN  std_logic_vector(N-1  downto  0);
			B : IN  std_logic_vector(N-1  downto  0);
			C : IN  std_logic_vector(N-1 downto 0);
			D : IN  std_logic_vector(N-1 downto 0);
			Y : OUT  std_logic_vector(N-1  downto  0)
		);
	end nor4N;
	
	signal andCenter_out : std_logic;
	signal andLeft_out : std_logic;
	signal andRight_out : std_logic;
	signal andOpposite_out : std_logic;
	
begin
	
	-- TODO: Check if components will be happy with 0 downto 0 defines.
	and_Center : andN
		GENERIC MAP(N => 1)
		PORT MAP(
			A => ControlUseCenter,
			B => CenterAdderResult,
			Y => andCenter_out
		);
	
	and_Left : andN
		GENERIC MAP(N => 1)
		PORT MAP(
			A => ControlUseLeft,
			B => LeftAdderResult,
			Y => andLeft_out
		);
	
	and_Right : andN
		GENERIC MAP(N => 1)
		PORT MAP(
			A => ControlUseRight,
			B => RightAdderResult,
			Y => andRight_out
		);
	
	and_Opposite : andN
		GENERIC MAP(N => 1)
		PORT MAP(
			A => ControlUseOpposite,
			B => OppositeByteAdderResult,
			Y => andOpposite_out
		);
		
	nor_output : nor4N
		GENERIC MAP(N => 1)
		PORT MAP(
			A => andCenter_out,
			B => andLeft_out,
			C => andRight_out,
			D => andOpposite_out,
			Y => Ouput
		);
		
	
end architecture;