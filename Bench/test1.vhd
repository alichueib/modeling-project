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

    --Now here we should execute some scenarios:
    -- Some scenarios:
    --1: food grabbed successfully
    --2: Food lost
    --3: Search Time Exceeded (reached search threshold)
    --4: Rest time Exceeded (reached rest thr)

    --senario one:
    -- This is just a random sequence, to test if stimulation is working: It is!
    process
    begin
        wait for 60 ns;
        findfood1 <= '1';
        wait for 10 ns;
        findfood1 <= '0';

        wait for 20 ns;
        closetofood1 <= '1';
        wait for 10 ns;
        closetofood1 <= '0';

        wait for 20 ns;
        success1 <= '1';
        wait for 10 ns;
        success1 <= '0';

        wait for 20 ns;
        athome1 <= '1';
        wait for 10 ns;
        athome1 <= '0';

        wait for 20 ns;
        success1 <= '1';
        wait for 10 ns;
        success1 <= '0';
    end process;


end test1;

configuration testconfig of testSystem is
    for test1
        for S : System use entity work.System(struct);
        end for;
    end for;
end testconfig;