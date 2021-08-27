------------------------------------------------------
-- Author        : Matthew Breidenbach
-- Design Name   : logic_input
-- Module Name   : logic_input
-- Architecture  : structural
-- Project Name  : pdp11_processor
-- Target Devices: Basys3
--
-- Description: Latch input as described in Figure 1-4
------------------------------------------------------

-- TODO: check if all libraries are needed
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity logic_input is
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

architecture structural of logic_input is
	
	-- TODO: find out of generics need defaults passed down into component instances
	component andN is
		GENERIC (N : INTEGER  := 16);
		PORT(
			A : IN  std_logic_vector(N-1  downto  0);
			B : IN  std_logic_vector(N-1  downto  0);
			Y : OUT  std_logic_vector(N-1  downto  0)
        );
	end andN;
	
	component norN is
		GENERIC (N : INTEGER  := 16);
		PORT(
			A : IN  std_logic_vector(N-1  downto  0);
			B : IN  std_logic_vector(N-1  downto  0);
			Y : OUT  std_logic_vector(N-1  downto  0)
		);
	end norN;
	
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
	
	component orN is
		GENERIC (N : INTEGER  := 16);
		PORT(
			A : IN  std_logic_vector(N-1  downto  0);
			B : IN  std_logic_vector(N-1  downto  0);
			Y : OUT  std_logic_vector(N-1  downto  0)
		);
	end orN;
	
	component notN is
		GENERIC (N : INTEGER  := 16);
		PORT(
			A : IN  std_logic_vector(N-1  downto  0);
			Y : OUT  std_logic_vector(N-1  downto  0)
		);
	end notN;
	
	-- TODO: remember how to write hex in vhdl
	-- TODO: check if starting value actually needs to be set for internal signals
	signal internal_output : std_logic_vector(15 downto 0) := "0000000000000000";
	signal andA_out : std_logic_vector(15 downto 0);
	signal andB_out : std_logic_vector(15 downto 0);
	signal andC_out : std_logic_vector(15 downto 0);
	signal not_latch : std_logic_vector(15 downto 0);
	signal nor_latch_out : std_logic_vector(15 downto 0);
	
begin
	
	and_A : andN
		GENERIC MAP(N => 16)
		PORT MAP(
			A => DataA,
			B => GateA,
			Y => andA_out
		);
	
	and_B : andN
		GENERIC MAP(N => 16)
		PORT MAP(
			A => DataB,
			B => GateB,
			Y => andB_out
		);
	
	and_C : andN
		GENERIC MAP(N => 16)
		PORT MAP(
			A => DataC,
			B => GateC,
			Y => andC_out
		);
	
	not1 : notN
		GENERIC MAP(N => 16)
		PORT MAP(
			A => Latch,
			Y => not_latch
		);
	
	nor_latch : norN
		GENERIC MAP(N => 16)
		PORT MAP(
			A => not_latch,
			B => internal_output,
			Y => nor_latch_out
		);
		
	nor_output : nor4N
		GENERIC MAP(N => 16)
		PORT MAP(
			A => nor_latch_out,
			B => andA_out,
			C => andB_out,
			D => andC_out,
			Y => internal_output
		);
		
	Output < = internal_output;
end architecture;