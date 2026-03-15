library ieee;
use ieee.std_logic_1164.all;

entity Count is 
	generic(threshold: natural);
	port(reset, clk, start: in std_logic; aboveth: out std_logic);
end Count;

architecture impl of count is

    type States is (idle, counting);

    signal state, nextstate : States;
    signal c, nextc : natural;

begin

	--next state:
    process (state, start, c)
    begin
        case state is

            when idle =>
                if start = '1' then
                    nextstate <= counting;
                    nextc     <= c + 1;
                else
                    nextstate <= idle;
                    nextc     <= c;
                end if;

            when counting =>
                if (c >= threshold) then
                    nextstate <= idle;
                    nextc <= 0; --since it was said that we should reset the counter
                else
                    nextstate <= counting;
                    nextc  <= c + 1; --here i will keep increasing counter until I reach thr
                end if;

        end case;
    end process;

	--state reg:
    process (reset, clk)
    begin
        if (reset = '1') then
            state <= idle;
            c     <= 0;

        elsif (clk'event and clk = '1') then
            state <= nextstate;
            c <= nextc;
        end if;
    end process;

	--output fct:
    aboveth <= '1' when ((state = counting) and (c >= threshold)) else '0';  -- the output assignment

end impl;