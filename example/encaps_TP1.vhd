library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY encaps_TP1 IS
PORT(
	adc_clk_p_i, adc_clk_n_i, Button : in STD_LOGIC;
	SW : in std_logic_vector(3 downto 0);
	gfedcba : OUT std_logic_vector (6 downto 0) -- gfedcba
	);	
END encaps_TP1;

ARCHITECTURE a OF encaps_TP1 IS
	COMPONENT seven_seg IS
	PORT(
		SW: in std_logic_vector (3 downto 0);
		gfedcba : OUT std_logic_vector (6 downto 0) -- gfedcba
		);	
	END COMPONENT;
	
	COMPONENT compt10s IS
	PORT(
		clk, raz: IN std_logic;
		Q : OUT std_logic_vector(3 downto 0)
		);	
	END COMPONENT ;
	
	COMPONENT IBUFDS is
		port(I, IB: IN std_logic;
			O : OUT std_logic);
	end COMPONENT;
	COMPONENT BUFG is
		port(I: IN std_logic;
			O : OUT std_logic);
	end COMPONENT;
	signal clk125, clk_nobuf_s : std_logic;
	signal compt : std_logic_vector (3 downto 0) ;
	
BEGIN
    clk_inst0: IBUFDS PORT MAP(I=>adc_clk_p_i,IB =>adc_clk_n_i,O =>clk_nobuf_s);
    clk_inst: BUFG  PORT MAP(I=>clk_nobuf_s, O=>clk125);

	c10s: compt10s PORT MAP(clk=>clk125, raz=>Button, Q=> compt);
	seven: seven_seg PORT MAP(SW=> compt, gfedcba => gfedcba);

END a;
