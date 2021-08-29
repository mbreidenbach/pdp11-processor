------------------------------------------------------
-- Author        : Matthew Breidenbach
-- Design Name   : adder_unit
-- Module Name   : adder_unit
-- Architecture  : structural 
-- Project Name  : pdp11_processor
-- Target Devices: Basys3
--
-- Description: The linking of multiple full adders
------------------------------------------------------

library ieee;
use IEEE.STD_LOGIC_1164.ALL;

entity adder_unit is
	GENERIC(N : integer := 16);
	PORT(
		A : IN std_logic_vector(N-1 downto 0);
		B : IN std_logic_vector(N-1 downto 0);
		K6_5Carry : IN std_logic;
		Sum : OUT std_logic_vector(N-1 downto 0);
		K8_2Carry : OUT std_logic
	);
end entity;

architecture structural of adder_unit is
	component full_adder is
		PORT(
			A : in std_logic;
			B : in std_logic;
			Cin : in std_logic;
			Y : out std_logic;
			Cout : out std_logic
		);
	end full_adder;
	
	signal Couts : std_logic_vector(N-1 downto 0);
begin
	full_adder0 : full_adder
		PORT MAP(
			A => A(0),
			B => B(0),
			Cin => K6_5Carry,
			Y => Sum(0),
			Cout => Couts(0)
		);
	
	adder_generate : for i in N-1 downto 1 generate
		full_adder_common : full_adder
			PORT MAP(
				A => A(i),
				B => B(i),
				Cin => Couts(i-1),
				Y => Sum(i),
				Cout => Couts(i)
			);
	end generate;
	
	K8_2Carry <= Couts(N-1);
end architecture;
