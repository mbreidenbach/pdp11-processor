------------------------------------------------------
-- Author        : Matthew Breidenbach
-- Design Name   : full_adder
-- Module Name   : full_adder
-- Architecture  : dataflow
-- Project Name  : pdp11_processor
-- Target Devices: Basys3
--
-- Description: A simple full adder
------------------------------------------------------

library ieee;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder is
	port(	A : in std_logic;
			B : in std_logic;
			Cin : in std_logic;
			Y : out std_logic;
			Cout : out std_logic
		);
end entity;

-- TODO: make into a structural design
architecture df of full_adder is

begin
	Y <= A XOR B XOR Cin;
	Cout <= (A AND B) OR (A AND Cin) OR (Cin AND B);
	
end architecture;