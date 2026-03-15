library ieee;
use ieee.std_logic_1164.all;

entity testSystem is
end testSystem;

architecture test1 of testSystem is
    component System 
        port(reset, clk,
        findfood, closetofood, lostfood, scantimeup,
        success, athome : in std_logic;
        food : out std_logic);
    end component;
    signal reset1, clk1, findfood1, closetofood1, lostfood1, scantimeup1, success1, athome1,food1: std_logic := '0';
begin
    S : System port map(
        reset1, clk1,
        findfood1, closetofood1, lostfood1, scantimeup1,
        success1, athome1,
        food1
    );


    process(clk1)
    begin
        clk1 <= not clk1 after 5 ns; --this should be the time matching the 100MHZ (as the period is 10ns), so half perios is 5
    end process;

    --NOTE: Scenario1 is good, but we can extend it with single state looping, to cover those scenarios!
    process
    begin
        --scenario1: "testing successfull retreival of food"
        
        -- --here we are at idle state:
        -- wait for 50 ns; -- this includes 10 for ensure changing the state from idle to Resting + 40 to finish resting

        -- --now here we should be at 'randomwalk' state
        -- findfood1 <= '1';
        -- wait for 10 ns;
        -- findfood1 <= '0';

        -- --here at 'movetofood':
        -- closetofood1 <= '1';
        -- wait for 10 ns;
        -- closetofood1 <= '0';

        -- --here at grabfood:
        -- success1 <= '1';
        -- wait for 10 ns;
        -- success1 <= '0';

        -- --here at movetohome:
        -- athome1 <= '1';
        -- wait for 10 ns;
        -- athome1 <= '0';

        -- --here at deposit:
        -- success1 <= '1';
        -- wait for 10 ns;
        -- success1 <= '0';

        -- --Here we should be back to resting:


        -- --senario 2: "Lets test rest threshold"
        
        -- --testing1: "Reach threshold from randomwalk state"
        -- wait for 50 ns; -- this includes 10 for ensure changing the state from idle to Resting + 40 to finish resting

        -- --now here we should be at 'randomwalk' state, so we will force the 10 cycles of search counters to finish, by waiting 100 ns,
        -- wait for 100 ns;


        -- --now we should be at homing (as we reached thr)
        -- athome1 <= '1';
        -- wait for 10 ns;
        -- athome1 <= '0';

        

        -- --testing2: "Reach threshold from movetofood state"
        -- --now I should be in resting again:
        -- wait for 40 ns; 

        -- --now at randomwalk:
        -- findfood1 <= '1';
        -- wait for 10 ns; 
        -- findfood1 <= '0';

        -- --now at movetofood
        -- wait for 90 ns; --waiting for more 9 cycles (to reach searchthr)

        -- --now at homing
        -- athome1 <= '1';
        -- wait for 10 ns;
        -- athome1 <= '0';

        -- --testing2: "Reach threshold from scanarena state"
        -- --now I should be in resting again:
        -- wait for 40 ns; 

        -- --now at randomwalk:
        -- findfood1 <= '1';
        -- wait for 10 ns; 
        -- findfood1 <= '0';

        -- --now at movefood:
        -- lostfood1 <= '1';
        -- wait for 10 ns;
        -- lostfood1 <= '0';

        -- --now at scanarena
        -- wait for 80 ns; --more 8 cycles to reach thr

        -- --now at resting again...


        --scenario three: "testing the reset"
        --idle:
        wait for 50 ns; 

        --now at randomwalk:
        findfood1 <= '1';
        wait for 10 ns; 
        --I will keep those set to see how everything will reset 
        findfood1 <= '0';

        --now at movefood:
        lostfood1 <= '1';
        wait for 10 ns;
        --I will keep those set to see how everything will reset 
        lostfood1 <= '0'; 

        --now at scanarena
        reset1 <= '1';
        wait for 10 ns;
        reset1 <= '0';


        --after this I should be at idle, with more 40 ns, I should be leaving resting to randomwalk
        wait for 40 ns;

        --Now I should be at randomwalk again!

    end process;


end test1;

configuration testconfig of testSystem is
    for test1
        for S : System use entity work.System(struct);
        end for;
    end for;
end testconfig;