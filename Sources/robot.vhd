library ieee;
use ieee.std_logic_1164.all;

entity Robot is
  port(reset, clk,
       findfood, -- location of the food has been identified
       closetofood, -- moving towards the food
       lostfood, -- location of the food has been lost
       scantimeup, -- scan time has expired
       success, -- the food has been grabbed, or deposited
       athome, -- control is given to exit the arena
       aboverestth, abovesearchth: in std_logic;
       rest, search, food: out std_logic);
end Robot;

architecture robot_behavior of Robot is
  type States is (idle, resting, randomwalk, movetofood, scanarena, grabfood, homing, movetohome, deposit);
  signal state, nextstate : States;
begin

  -- next state process:
  process(state, findfood, closetofood, lostfood, scantimeup, success, athome, aboverestth, abovesearchth)
  begin
    case state is
      --idle:
      when idle =>
        nextstate <= resting;
        
      --resting:
      when resting =>
        if aboverestth = '1' then
          nextstate <= randomwalk;

        else
          nextstate <= resting;
        end if;
      
      --randomwalk:
      when randomwalk =>
        if abovesearchth = '1' then
          nextstate <= homing;

        elsif abovesearchth = '0' and findfood = '1' then
          nextstate <= movetofood;

        else 
          nextstate <= randomwalk;  
        end if;
      
      --movetofood:
      when movetofood =>
        if abovesearchth = '1' then
          nextstate <= homing;

        elsif abovesearchth = '0' and lostfood = '1' then
          nextstate <= scanarena;

        elsif abovesearchth = '0' and lostfood = '0' and closetofood = '1' then
          nextstate <= grabfood;

        else
          nextstate <= movetofood;
	      end if;
      
      --scanarena:
      when scanarena =>
        if abovesearchth = '1' then
          nextstate <= homing;

        elsif abovesearchth = '0' and findfood = '1' then
          nextstate <= movetofood;

        elsif abovesearchth = '0' and findfood = '0' and scantimeup = '1' then
          nextstate <= randomwalk;
          
        else
          nextstate <= scanarena;
        end if;
      
      --homing:
      when homing =>
          if athome = '1' then
             nextstate <= resting;
          
          else
            nextstate <= homing;
          end if;
      
      --grabfood:
      when grabfood =>
          if success = '1' then
             nextstate <= movetohome;

          else
            nextstate <= grabfood;
          end if;
      
      --movetohome:
      when movetohome =>
          if athome = '1' then
             nextstate <= deposit;

          else
            nextstate <= movetohome;
          end if;

      --deposit:
      when deposit =>
          if success = '1' then
             nextstate <= resting;

          else
            nextstate <= deposit;
          end if;

     end case;
  end process;

  -- Updating of the state register process:
  process(clk, reset)
  begin
    if (reset = '1') then
      state <= idle;
    elsif (clk'event and clk='1') then
      state <= nextstate;
    end if;
  end process;


  -- output fct process:
  process(state, findfood, closetofood, lostfood, scantimeup, success, athome, aboverestth, abovesearchth)
  begin 

    --search:
    if (state = resting) and (aboverestth = '1') then
      search <= '1';
    else
      search <= '0';
    end if;

    --food:
    if (state = movetofood) and (closetofood = '1') then
      food <= '1';
    else
      food <= '0';
    end if;

    --rest:
    if (state = idle) then
      rest <= '1';
    elsif (state = homing) and (athome = '1') then
       rest <= '1';
    elsif (state = deposit) and (success = '1') then
       rest <= '1';
    else
      rest <= '0';
    end if;

  end process;

end robot_behavior;



