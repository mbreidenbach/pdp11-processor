------------------------------------------------------
-- Author        : Matthew Breidenbach
-- Design Name   : andN
-- Module Name   : andN
-- Architecture  : dataflow
-- Project Name  : pdp11_processor
-- Target Devices: Basys3
--
-- Description: N-bit  bitwise  AND  unit
------------------------------------------------------

library  IEEE;
use  IEEE.STD_LOGIC_1164.ALL;

entity andN is
    GENERIC (N : INTEGER  := 16); --bit  width
    PORT(
        A : IN  std_logic_vector(N-1  downto  0);
		B : IN  std_logic_vector(N-1  downto  0);
        Y : OUT  std_logic_vector(N-1  downto  0)
        );
end andN;

architecture  dataflow  of andN is
begin
    Y <= A and B;
end  dataflow;