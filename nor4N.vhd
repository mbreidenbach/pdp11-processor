------------------------------------------------------
-- Author        : Matthew Breidenbach
-- Design Name   : nor4N
-- Module Name   : nor4N
-- Architecture  : dataflow
-- Project Name  : pdp11_processor
-- Target Devices: Basys3
--
-- Description: 4-way N-bit  bitwise  NOR  unit
------------------------------------------------------

library  IEEE;
use  IEEE.STD_LOGIC_1164.ALL;

entity nor4N is
    GENERIC (N : INTEGER  := 16); --bit  width
    PORT(
        A : IN  std_logic_vector(N-1  downto  0);
		B : IN  std_logic_vector(N-1  downto  0);
		C : IN  std_logic_vector(N-1 downto 0);
		D : IN  std_logic_vector(N-1 downto 0);
        Y : OUT  std_logic_vector(N-1  downto  0)
    );
end nor4N;

architecture  dataflow  of nor4N is
begin
    Y <= A nor B nor C nor D;
end  dataflow;