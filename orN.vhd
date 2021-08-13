------------------------------------------------------
-- Author        : Matthew Breidenbach
-- Design Name   : orN
-- Module Name   : orN
-- Architecture  : dataflow
-- Project Name  : pdp11_processor
-- Target Devices: Basys3
--
-- Description: N-bit  bitwise  NOR  unit
------------------------------------------------------

library  IEEE;
use  IEEE.STD_LOGIC_1164.ALL;

entity orN is
    GENERIC (N : INTEGER  := 16); --bit  width
    PORT(
        A : IN  std_logic_vector(N-1  downto  0);
		B : IN  std_logic_vector(N-1  downto  0);
        Y : OUT  std_logic_vector(N-1  downto  0)
    );
end orN;

architecture  dataflow  of orN is
begin
    Y <= A or B;
end  dataflow;