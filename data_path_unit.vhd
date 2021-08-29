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
	);
end entity;