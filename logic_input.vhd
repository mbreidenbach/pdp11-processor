------------------------------------------------------
-- Author        : Matthew Breidenbach
-- Design Name   : logic_input
-- Module Name   : logic_input
-- Architecture  : structural
-- Project Name  : pdp11_processor
-- Target Devices: Basys3
--
-- Description: Latch input as described in Figure 1-3
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
begin
	
	component andN is
		PORT(
			A : IN  std_logic_vector(N-1  downto  0);
			B : IN  std_logic_vector(N-1  downto  0);
			Y : OUT  std_logic_vector(N-1  downto  0)
        );
	end andN;
	
	component norN is
		PORT(
			A : IN  std_logic_vector(N-1  downto  0);
			B : IN  std_logic_vector(N-1  downto  0);
			Y : OUT  std_logic_vector(N-1  downto  0)
		);
	end norN;
	
	component orN is
		PORT(
			A : IN  std_logic_vector(N-1  downto  0);
			B : IN  std_logic_vector(N-1  downto  0);
			Y : OUT  std_logic_vector(N-1  downto  0)
		);
	end orN;
	
	component notN is
		PORT(
			A : IN  std_logic_vector(N-1  downto  0);
			Y : OUT  std_logic_vector(N-1  downto  0)
		);
	end notN;
	