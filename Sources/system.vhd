library ieee;
use ieee.std_logic_1164.all;

entity System is
    port(
        reset, clk,
        findfood, closetofood, lostfood, scantimeup,
        success, athome : in std_logic;
        food : out std_logic
    );
end System;


architecture Struct of System is
    --Here first we write declaration of subcomponents
    component Robot
        port(
            reset, clk, findfood, closetofood, lostfood, scantimeup, success, athome, aboverestth, abovesearchth: in std_logic;
            rest, search, food: out std_logic
        );
    end component;

    component Count
        generic(threshold : natural);
        port(
            reset, clk, start: in std_logic; aboveth: out std_logic
        );
    end component;
    --then decl of internation signals:
    signal rest, search, aboverestth, abovesearchth: std_logic;
begin
    R : Robot port map (
        reset => reset,
        clk => clk,
        findfood => findfood,
        closetofood => closetofood,
        lostfood => lostfood,
        scantimeup => scantimeup,
        success => success,
        athome => athome,
        aboverestth => aboverestth,
        abovesearchth => abovesearchth,
        rest => rest,
        search => search,
        food => food
    );
    Count1 : Count 
        generic map(threshold => 4)
        port map(reset => reset, clk => clk, start => rest, aboveth => aboverestth);
    Count2 : Count 
        generic map(threshold => 10)
        port map(reset => reset, clk => clk, start => search, aboveth => abovesearchth);
end Struct;

configuration config1 of System is
    for Struct
        for R : Robot
            use entity work.Robot(robot_behavior);
        end for;
        for Count1 : Count
            use entity work.Count(impl);
        end for;
        for Count2 : Count
            use entity work.Count(impl);
        end for;
    end for;
end config1;