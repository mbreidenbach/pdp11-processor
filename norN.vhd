------------------------------------------------------
-- Author        : Matthew Breidenbach
-- Design Name   : norN
-- Module Name   : norN
-- Architecture  : dataflow
-- Project Name  : pdp11_processor
-- Target Devices: Basys3
--
-- Description: N-bit  bitwise  NOR  unit
------------------------------------------------------

library  IEEE;
use  IEEE.STD_LOGIC_1164.ALL;

entity norN is
    GENERIC (N : INTEGER  := 16); --bit  width
    PORT(
        A : IN  std_logic_vector(N-1  downto  0);
		B : IN  std_logic_vector(N-1  downto  0);
        Y : OUT  std_logic_vector(N-1  downto  0)
        );
end norN;

architecture  dataflow  of andN is
begin
    Y <= A nor B;
end  dataflow;