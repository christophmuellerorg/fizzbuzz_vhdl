library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FizzBuzz is
  
  port (
    clk       : in  std_logic;          -- clock
    nRST      : in  std_logic;          -- asynchronous low active reset
    is_fizz   : out std_logic;          -- it is fizz
    is_buzz   : out std_logic;          -- it is buzz
    is_number : out std_logic;          -- it is a number
    number    : out unsigned(6 downto 0));  -- 7 bit unsigned int

end FizzBuzz;

architecture Implementation of FizzBuzz is

  type FIZZ_FSM is (ONE, TWO, FIZZ);               -- three states for fizz
  type BUZZ_FSM is (ONE, TWO, THREE, FOUR, BUZZ);  -- five states for buzz

  signal FIZZ_STATE, NEXT_FIZZ_STATE : FIZZ_FSM;  -- register for FIZZ STATE
  signal BUZZ_STATE, NEXT_BUZZ_STATE : BUZZ_FSM;  -- register for BUZZ STATE
  signal i, next_i                   : unsigned(number'range);  -- register for the number

  signal fizz_signal, buzz_signal, number_signal : std_logic;

begin  -- Implementation

  -- purpose: combinatorical logic
  -- type   : combinational
  -- inputs : FIZZ_STATE, BUZZ_STATE, i
  -- outputs: NEXT_FIZZ_STATE, NEXT_BUZZ_STATE, next_i, fizz_signal, buzz_signal, number_signal
  comb : process (FIZZ_STATE, BUZZ_STATE, i)
  begin  -- process comb
    -- default values
    fizz_signal <= '0';
    buzz_signal <= '0';
  number_signal <= '1';
    next_i <= i;
    NEXT_FIZZ_STATE <= FIZZ_STATE;
    NEXT_BUZZ_STATE <= BUZZ_STATE;
    if i < 100 then
      -- fizz!
      case FIZZ_STATE is
        when ONE  => NEXT_FIZZ_STATE <= TWO;
        when TWO  => NEXT_FIZZ_STATE <= FIZZ;
        when FIZZ => NEXT_FIZZ_STATE <= ONE;
                     fizz_signal   <= '1';
                     number_signal <= '0';
      end case;
      -- buzz!
      case BUZZ_STATE is
        when ONE   => NEXT_BUZZ_STATE <= TWO;
        when TWO   => NEXT_BUZZ_STATE <= THREE;
        when THREE => NEXT_BUZZ_STATE <= FOUR;
        when FOUR  => NEXT_BUZZ_STATE <= BUZZ;
        when BUZZ  => NEXT_BUZZ_STATE <= ONE;
                     buzz_signal   <= '1';
                     number_signal <= '0';
      end case;
      next_i <= i + 1;
    end if;
    

  end process comb;

  -- purpose: state transitions
  -- type   : sequential
  -- inputs : clk, nRST
  -- outputs: 
  seq : process (clk, nRST)
  begin  -- process seq
    if nRST = '0' then                  -- asynchronous reset (active low)
      i          <=  to_unsigned(1,i'length);
      FIZZ_STATE <= ONE;
      BUZZ_STATE <= ONE;
    elsif clk'event and clk = '1' then  -- rising clock edge
      FIZZ_STATE <= NEXT_FIZZ_STATE;
      BUZZ_STATE <= NEXT_BUZZ_STATE;
      i          <= next_i;
    end if;
  end process seq;

  is_buzz   <= buzz_signal;
  is_fizz   <= fizz_signal;
  is_number <= number_signal;
  number    <= i;
  
end Implementation;
