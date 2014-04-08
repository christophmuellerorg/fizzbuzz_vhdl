-------------------------------------------------------------------------------
-- Title      : Testbench for design "FizzBuzz"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : FizzBuzz_tb.vhdl
-- Author     : Christoph Müller  <chm@fenchurch.lan>
-- Company    : Lund University
-- Created    : 2012-10-21
-- Last update: 2014-04-08
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2012 Lund University
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-10-21  1.0      chm     Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity FizzBuzz_tb is

end FizzBuzz_tb;

-------------------------------------------------------------------------------

architecture fbdut of FizzBuzz_tb is

  component FizzBuzz
    port (
      clk       : in  std_logic;
      nRST      : in  std_logic;
      is_fizz   : out std_logic;
      is_buzz   : out std_logic;
      is_number : out std_logic;
      number    : out unsigned(6 downto 0));
  end component;

  -- component ports
  signal clk       : std_logic := '0';
  signal nRST      : std_logic := '0';
  signal is_fizz   : std_logic;
  signal is_buzz   : std_logic;
  signal is_number : std_logic;
  signal number    : unsigned(6 downto 0);
  signal simulation_done  : boolean := false;

begin  -- dut

  -- component instantiation
  DUT : FizzBuzz
    port map (
      clk       => clk,
      nRST      => nRST,
      is_fizz   => is_fizz,
      is_buzz   => is_buzz,
      is_number => is_number,
      number    => number);

  -- clock generation
  clkgen: process
  begin  -- process
    wait for 10 ns;
    clk  <= not clk;
    if simulation_done then
      wait;
    end if;
  end process;

  -- reset
  nRST <= '1'     after 80 ns;
  
  -- waveform generation
  WaveGen_Proc : process
  begin
    -- insert signal assignments here
    wait until clk = '1';
    if nRST = '1' then
      if is_fizz = '1' and is_buzz = '1' then
        report "FIZZBUZZ" severity note;
      elsif is_fizz = '1' then
        report "FIZZ" severity note;
      elsif is_buzz = '1' then
        report "BUZZ" severity note;
      elsif is_number = '1' then
        report integer'image(to_integer(number)) severity note;
      end if;
    end if;
    if number = 100 then
      simulation_done <= true;
    end if;
  end process WaveGen_Proc;

  

end fbdut;

-------------------------------------------------------------------------------

configuration FizzBuzz_tb_dut_cfg of FizzBuzz_tb is
  for fbdut
  end for;
end FizzBuzz_tb_dut_cfg;

-------------------------------------------------------------------------------
