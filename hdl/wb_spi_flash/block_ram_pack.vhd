library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

package block_ram_pack is

  component block_ram_dp_const_init
    generic(
      init_value : integer;
      adr_width  : integer;
      dat_width  : integer
    );
    port (     
       clk_a     : in  std_logic;
       clk_b     : in  std_logic;

       adr_a_i   : in  unsigned(adr_width-1 downto 0);
       adr_b_i   : in  unsigned(adr_width-1 downto 0);

       we_a_i    : in  std_logic;
       en_a_i    : in  std_logic;
       dat_a_i   : in  unsigned(dat_width-1 downto 0);
       dat_a_o   : out unsigned(dat_width-1 downto 0);
       
       we_b_i    : in  std_logic;
       en_b_i    : in  std_logic;
       dat_b_i   : in  unsigned(dat_width-1 downto 0);
       dat_b_o   : out unsigned(dat_width-1 downto 0)
    );
  end component;

  component block_ram_dp_writethrough_const_init
    generic(
      init_value : integer;
      adr_width  : integer;
      dat_width  : integer
    );
    port (     
       clk_a     : in  std_logic;
       clk_b     : in  std_logic;

       adr_a_i   : in  unsigned(adr_width-1 downto 0);
       adr_b_i   : in  unsigned(adr_width-1 downto 0);

       we_a_i    : in  std_logic;
       en_a_i    : in  std_logic;
       dat_a_i   : in  unsigned(dat_width-1 downto 0);
       dat_a_o   : out unsigned(dat_width-1 downto 0);
       
       we_b_i    : in  std_logic;
       en_b_i    : in  std_logic;
       dat_b_i   : in  unsigned(dat_width-1 downto 0);
       dat_b_o   : out unsigned(dat_width-1 downto 0)
    );
  end component;

  component block_ram_dp_writethrough_file_init
    generic(
      init_file      : string  := ".\bram_1.txt";
      adr_width      : integer;
      dat_width      : integer
    );
    port (     
       clk_a         : in  std_logic;
       clk_b         : in  std_logic;

       adr_a_i       : in  unsigned(adr_width-1 downto 0);
       adr_b_i       : in  unsigned(adr_width-1 downto 0);

       we_a_i        : in  std_logic;
       en_a_i        : in  std_logic;
       dat_a_i       : in  unsigned(dat_width-1 downto 0);
       dat_a_o       : out unsigned(dat_width-1 downto 0);

       we_b_i        : in  std_logic;
       en_b_i        : in  std_logic;
       dat_b_i       : in  unsigned(dat_width-1 downto 0);
       dat_b_o       : out unsigned(dat_width-1 downto 0)
    );
  end component;

  component block_ram_dp_writethrough_hexfile_init
    generic(
      init_file      : string  := ".\bram_1.txt";
      fil_width      : integer; -- Bit width of init file lines
      adr_width      : integer;
      dat_width      : integer
    );
    port (     
       clk_a         : in  std_logic;
       clk_b         : in  std_logic;

       adr_a_i       : in  unsigned(adr_width-1 downto 0);
       adr_b_i       : in  unsigned(adr_width-1 downto 0);

       we_a_i        : in  std_logic;
       en_a_i        : in  std_logic;
       dat_a_i       : in  unsigned(dat_width-1 downto 0);
       dat_a_o       : out unsigned(dat_width-1 downto 0);

       we_b_i        : in  std_logic;
       en_b_i        : in  std_logic;
       dat_b_i       : in  unsigned(dat_width-1 downto 0);
       dat_b_o       : out unsigned(dat_width-1 downto 0)
    );
  end component;

  component block_ram_dp
    generic(
      adr_width      : integer;
      dat_width      : integer
    );
    port (     
       clk_a         : in  std_logic;
       clk_b         : in  std_logic;

       adr_a_i       : in  unsigned(adr_width-1 downto 0);
       adr_b_i       : in  unsigned(adr_width-1 downto 0);

       we_a_i        : in  std_logic;
       en_a_i        : in  std_logic;
       dat_a_i       : in  unsigned(dat_width-1 downto 0);
       dat_a_o       : out unsigned(dat_width-1 downto 0);
       
       we_b_i        : in  std_logic;
       en_b_i        : in  std_logic;
       dat_b_i       : in  unsigned(dat_width-1 downto 0);
       dat_b_o       : out unsigned(dat_width-1 downto 0)
    );
  end component;

  component block_ram_sp_file_init
    generic(
      init_file      : string  := ".\bram_1.txt";
      adr_width      : integer;
      dat_width      : integer
    );
    port (     
       clk_a         : in  std_logic;

       adr_a_i       : in  unsigned(adr_width-1 downto 0);

       we_a_i        : in  std_logic;
       en_a_i        : in  std_logic;
       dat_a_i       : in  unsigned(dat_width-1 downto 0);
       dat_a_o       : out unsigned(dat_width-1 downto 0)
    );
  end component;

  component block_ram_sp_writethrough_file_init
    generic(
      init_file      : string  := ".\bram_1.txt";
      adr_width      : integer;
      dat_width      : integer
    );
    port (     
       clk_a         : in  std_logic;

       adr_a_i       : in  unsigned(adr_width-1 downto 0);

       we_a_i        : in  std_logic;
       en_a_i        : in  std_logic;
       dat_a_i       : in  unsigned(dat_width-1 downto 0);
       dat_a_o       : out unsigned(dat_width-1 downto 0)
    );
  end component;

  component block_ram_sp
    generic(
      adr_width      : integer;
      dat_width      : integer
    );
    port (     
       clk_a         : in  std_logic;

       adr_a_i       : in  unsigned(adr_width-1 downto 0);

       we_a_i        : in  std_logic;
       en_a_i        : in  std_logic;
       dat_a_i       : in  unsigned(dat_width-1 downto 0);
       dat_a_o       : out unsigned(dat_width-1 downto 0)
    );
  end component;

end block_ram_pack;

------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

library std ;
use std.textio.all;

entity block_ram_dp_const_init is
    generic(
      init_value : integer := 0;
      adr_width  : integer := 3;
      dat_width  : integer := 8
    );
    port (     
       clk_a     : in  std_logic;
       clk_b     : in  std_logic;

       adr_a_i   : in  unsigned(adr_width-1 downto 0);
       adr_b_i   : in  unsigned(adr_width-1 downto 0);

       we_a_i    : in  std_logic;
       en_a_i    : in  std_logic;
       dat_a_i   : in  unsigned(dat_width-1 downto 0);
       dat_a_o   : out unsigned(dat_width-1 downto 0);
       
       we_b_i    : in  std_logic;
       en_b_i    : in  std_logic;
       dat_b_i   : in  unsigned(dat_width-1 downto 0);
       dat_b_o   : out unsigned(dat_width-1 downto 0)
    );
end block_ram_dp_const_init;

architecture beh of block_ram_dp_const_init is

  -- Constants

  -- Functions & associated types
    type ram_array is array(0 to 2**adr_width-1) of unsigned(dat_width-1 downto 0);
    impure function ram_const_init (init_value : in integer) return ram_array is
      variable rambo : ram_array;
    begin
      for I in ram_array'range loop
        rambo(I):=to_unsigned(init_value,dat_width);
      end loop;
      return rambo;
    end function;

    shared variable ram1 : ram_array := ram_const_init(init_value);

  -- Signal Declarations
--  type ram_array is array (2**adr_width-1 downto 0) of unsigned(dat_width-1 downto 0);
--  shared variable ram1 : ram_array;

begin

process (clk_a)
begin
   if (clk_a'event and clk_a='1') then
      if (en_a_i='1') then
         if (we_a_i='1') then
            ram1(to_integer(adr_a_i)) := dat_a_i;
         end if;
         dat_a_o <= ram1(to_integer(adr_a_i));
      end if;
   end if;
end process;

process (clk_b)
begin
   if (clk_b'event and clk_b='1') then
      if (en_b_i='1') then
         if (we_b_i='1') then
            ram1(to_integer(adr_b_i)) := dat_b_i;
         end if;
         dat_b_o <= ram1(to_integer(adr_b_i));
      end if;
   end if;
end process;

end beh;

------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

library std ;
use std.textio.all;

entity block_ram_dp_writethrough_const_init is
    generic(
      init_value : integer := 0;
      adr_width  : integer := 3;
      dat_width  : integer := 8
    );
    port (     
       clk_a     : in  std_logic;
       clk_b     : in  std_logic;

       adr_a_i   : in  unsigned(adr_width-1 downto 0);
       adr_b_i   : in  unsigned(adr_width-1 downto 0);

       we_a_i    : in  std_logic;
       en_a_i    : in  std_logic;
       dat_a_i   : in  unsigned(dat_width-1 downto 0);
       dat_a_o   : out unsigned(dat_width-1 downto 0);
       
       we_b_i    : in  std_logic;
       en_b_i    : in  std_logic;
       dat_b_i   : in  unsigned(dat_width-1 downto 0);
       dat_b_o   : out unsigned(dat_width-1 downto 0)
    );
end block_ram_dp_writethrough_const_init;

architecture beh of block_ram_dp_writethrough_const_init is

  -- Constants

  -- Functions & associated types
    type ram_array is array(0 to 2**adr_width-1) of unsigned(dat_width-1 downto 0);
    impure function ram_const_init (init_value : in integer) return ram_array is
      variable rambo : ram_array;
    begin
      for I in ram_array'range loop
        rambo(I):=to_unsigned(init_value,dat_width);
      end loop;
      return rambo;
    end function;

    shared variable ram1 : ram_array := ram_const_init(init_value);

  -- Signal Declarations
--  type ram_array is array (2**adr_width-1 downto 0) of unsigned(dat_width-1 downto 0);
--  shared variable ram1 : ram_array;

begin

process (clk_a)
begin
   if (clk_a'event and clk_a='1') then
      if (en_a_i='1') then
         if (we_a_i='1') then
           ram1(to_integer(adr_a_i)) := dat_a_i;
           dat_a_o <= dat_a_i;
         else
           dat_a_o <= ram1(to_integer(adr_a_i));
         end if;
      end if;
   end if;
end process;

process (clk_b)
begin
   if (clk_b'event and clk_b='1') then
      if (en_b_i='1') then
         if (we_b_i='1') then
           ram1(to_integer(adr_b_i)) := dat_b_i;
           dat_b_o <= dat_b_i;
         else
           dat_b_o <= ram1(to_integer(adr_b_i));
         end if;
      end if;
   end if;
end process;

end beh;

------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

library std ;
use std.textio.all;

entity block_ram_dp_writethrough_file_init is
    generic(
      init_file      : string  := ".\bram_1.txt";
      adr_width      : integer := 3;
      dat_width      : integer := 32
    );
    port (     
       clk_a         : in  std_logic;
       clk_b         : in  std_logic;

       adr_a_i       : in  unsigned(adr_width-1 downto 0);
       adr_b_i       : in  unsigned(adr_width-1 downto 0);

       we_a_i        : in  std_logic;
       en_a_i        : in  std_logic;
       dat_a_i       : in  unsigned(dat_width-1 downto 0);
       dat_a_o       : out unsigned(dat_width-1 downto 0);
       
       we_b_i        : in  std_logic;
       en_b_i        : in  std_logic;
       dat_b_i       : in  unsigned(dat_width-1 downto 0);
       dat_b_o       : out unsigned(dat_width-1 downto 0)
    );
end block_ram_dp_writethrough_file_init;

architecture beh of block_ram_dp_writethrough_file_init is

  -- Constants

  -- Functions & associated types
    type ram_array is array(0 to 2**adr_width-1) of unsigned(dat_width-1 downto 0);
    impure function ram_file_init (init_file : in string) return ram_array is
      FILE F1 : text is in init_file; 
      variable ligne : line;  
      variable rambo : ram_array;
      variable vect  : bit_vector(dat_width-1 downto 0);
      variable uvect : unsigned(dat_width-1 downto 0);
    begin
      for I in ram_array'range loop
         readline(F1,ligne);
         read (ligne,vect);
         for j in vect'range loop
           if (vect(j)='1') then
             uvect(j):='1';
           else
             uvect(j):='0';
           end if;
         end loop;
         rambo(I):=uvect;
      end loop;
      return rambo;
    end function;

    shared variable ram1 : ram_array := ram_file_init(init_file);

  -- Signal Declarations
--  type ram_array is array (2**adr_width-1 downto 0) of unsigned(dat_width-1 downto 0);
--  shared variable ram1 : ram_array;

begin

process (clk_a)
begin
   if (clk_a'event and clk_a='1') then
      if (en_a_i='1') then
         if (we_a_i='1') then
           ram1(to_integer(adr_a_i)) := dat_a_i;
           dat_a_o <= dat_a_i;
         else
           dat_a_o <= ram1(to_integer(adr_a_i));
         end if;
      end if;
   end if;
end process;

process (clk_b)
begin
   if (clk_b'event and clk_b='1') then
      if (en_b_i='1') then
         if (we_b_i='1') then
           ram1(to_integer(adr_b_i)) := dat_b_i;
           dat_b_o <= dat_b_i;
         else
           dat_b_o <= ram1(to_integer(adr_b_i));
         end if;
      end if;
   end if;
end process;

end beh;

------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity block_ram_dp_writethrough_hexfile_init is
    generic(
      init_file      : string  := ".\bram_1.txt";
      fil_width      : integer := 32; -- Bit width of init file lines
      adr_width      : integer := 3;
      dat_width      : integer := 32
    );
    port (     
       clk_a         : in  std_logic;
       clk_b         : in  std_logic;

       adr_a_i       : in  unsigned(adr_width-1 downto 0);
       adr_b_i       : in  unsigned(adr_width-1 downto 0);

       we_a_i        : in  std_logic;
       en_a_i        : in  std_logic;
       dat_a_i       : in  unsigned(dat_width-1 downto 0);
       dat_a_o       : out unsigned(dat_width-1 downto 0);
       
       we_b_i        : in  std_logic;
       en_b_i        : in  std_logic;
       dat_b_i       : in  unsigned(dat_width-1 downto 0);
       dat_b_o       : out unsigned(dat_width-1 downto 0)
    );
end block_ram_dp_writethrough_hexfile_init;

architecture beh of block_ram_dp_writethrough_hexfile_init is

  -- Constants

  -- Functions & associated types
    type ram_array is array(0 to 2**adr_width-1) of unsigned(dat_width-1 downto 0);
    impure function ram_file_init (init_file : in string) return ram_array is
      FILE F1 : text is in init_file; 
      variable ligne : line;  
      variable rambo : ram_array;
      variable vect  : std_logic_vector(fil_width-1 downto 0);
      variable uvect : unsigned(dat_width-1 downto 0);
    begin
      for I in ram_array'range loop
         readline(F1,ligne);
         hread(ligne,vect);
         for j in uvect'range loop
           if (vect(j)='1') then
             uvect(j):='1';
           else
             uvect(j):='0';
           end if;
         end loop;
         rambo(I):=uvect;
      end loop;
      return rambo;
    end function;

    shared variable ram1 : ram_array := ram_file_init(init_file);

  -- Signal Declarations
--  type ram_array is array (2**adr_width-1 downto 0) of unsigned(dat_width-1 downto 0);
--  shared variable ram1 : ram_array;

begin

process (clk_a)
begin
   if (clk_a'event and clk_a='1') then
      if (en_a_i='1') then
         if (we_a_i='1') then
           ram1(to_integer(adr_a_i)) := dat_a_i;
           dat_a_o <= dat_a_i;
         else
           dat_a_o <= ram1(to_integer(adr_a_i));
         end if;
      end if;
   end if;
end process;

process (clk_b)
begin
   if (clk_b'event and clk_b='1') then
      if (en_b_i='1') then
         if (we_b_i='1') then
           ram1(to_integer(adr_b_i)) := dat_b_i;
           dat_b_o <= dat_b_i;
         else
           dat_b_o <= ram1(to_integer(adr_b_i));
         end if;
      end if;
   end if;
end process;

end beh;

------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity block_ram_dp is
    generic(
      adr_width      : integer := 7;
      dat_width      : integer := 8
    );
    port (     
       clk_a         : in  std_logic;
       clk_b         : in  std_logic;

       adr_a_i       : in  unsigned(adr_width-1 downto 0);
       adr_b_i       : in  unsigned(adr_width-1 downto 0);

       we_a_i        : in  std_logic;
       en_a_i        : in  std_logic;
       dat_a_i       : in  unsigned(dat_width-1 downto 0);
       dat_a_o       : out unsigned(dat_width-1 downto 0);
       
       we_b_i        : in  std_logic;
       en_b_i        : in  std_logic;
       dat_b_i       : in  unsigned(dat_width-1 downto 0);
       dat_b_o       : out unsigned(dat_width-1 downto 0)
    );
end block_ram_dp;

architecture beh of block_ram_dp is

  -- Constants

  -- Signal Declarations
  type ram_array is array (2**adr_width-1 downto 0) of unsigned(dat_width-1 downto 0);
  shared variable ram1 : ram_array;

begin

process (clk_a)
begin
   if (clk_a'event and clk_a='1') then
      if (en_a_i='1') then
         if (we_a_i='1') then
            ram1(to_integer(adr_a_i)) := dat_a_i;
         end if;
         dat_a_o <= ram1(to_integer(adr_a_i));
      end if;
   end if;
end process;

process (clk_b)
begin
   if (clk_b'event and clk_b='1') then
      if (en_b_i='1') then
         if (we_b_i='1') then
            ram1(to_integer(adr_b_i)) := dat_b_i;
         end if;
         dat_b_o <= ram1(to_integer(adr_b_i));
      end if;
   end if;
end process;

end beh;

------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

library std ;
use std.textio.all;

entity block_ram_sp_file_init is
    generic(
      init_file      : string  := ".\bram_1.txt";
      adr_width      : integer := 3;
      dat_width      : integer := 32
    );
    port (     
       clk_a         : in  std_logic;

       adr_a_i       : in  unsigned(adr_width-1 downto 0);

       we_a_i        : in  std_logic;
       en_a_i        : in  std_logic;
       dat_a_i       : in  unsigned(dat_width-1 downto 0);
       dat_a_o       : out unsigned(dat_width-1 downto 0)
       
    );
end block_ram_sp_file_init;

architecture beh of block_ram_sp_file_init is

  -- Constants

  -- Functions & associated types
    type ram_array is array(0 to 2**adr_width-1) of unsigned(dat_width-1 downto 0);
    impure function ram_file_init (init_file : in string) return ram_array is
      FILE F1 : text is in init_file; 
      variable ligne : line;  
      variable rambo : ram_array;
      variable vect  : bit_vector(dat_width-1 downto 0);
      variable uvect : unsigned(dat_width-1 downto 0);
    begin
      for I in ram_array'range loop
         readline(F1,ligne);
         read (ligne,vect);
         for j in vect'range loop
           if (vect(j)='1') then
             uvect(j):='1';
           else
             uvect(j):='0';
           end if;
         end loop;
         rambo(I):=uvect;
      end loop;
      return rambo;
    end function;

    shared variable ram1 : ram_array := ram_file_init(init_file);

  -- Signal Declarations
--  type ram_array is array (2**adr_width-1 downto 0) of unsigned(dat_width-1 downto 0);
--  shared variable ram1 : ram_array;

begin

process (clk_a)
begin
   if (clk_a'event and clk_a='1') then
      if (en_a_i='1') then
         if (we_a_i='1') then
           ram1(to_integer(adr_a_i)) := dat_a_i;
         end if;
         dat_a_o <= ram1(to_integer(adr_a_i));
      end if;
   end if;
end process;

end beh;

------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

library std ;
use std.textio.all;

entity block_ram_sp_writethrough_file_init is
    generic(
      init_file      : string  := ".\bram_1.txt";
      adr_width      : integer := 3;
      dat_width      : integer := 32
    );
    port (     
       clk_a         : in  std_logic;

       adr_a_i       : in  unsigned(adr_width-1 downto 0);

       we_a_i        : in  std_logic;
       en_a_i        : in  std_logic;
       dat_a_i       : in  unsigned(dat_width-1 downto 0);
       dat_a_o       : out unsigned(dat_width-1 downto 0)
       
    );
end block_ram_sp_writethrough_file_init;

architecture beh of block_ram_sp_writethrough_file_init is

  -- Constants

  -- Functions & associated types
    type ram_array is array(0 to 2**adr_width-1) of unsigned(dat_width-1 downto 0);
    impure function ram_file_init (init_file : in string) return ram_array is
      FILE F1 : text is in init_file; 
      variable ligne : line;  
      variable rambo : ram_array;
      variable vect  : bit_vector(dat_width-1 downto 0);
      variable uvect : unsigned(dat_width-1 downto 0);
    begin
      for I in ram_array'range loop
         readline(F1,ligne);
         read (ligne,vect);
         for j in vect'range loop
           if (vect(j)='1') then
             uvect(j):='1';
           else
             uvect(j):='0';
           end if;
         end loop;
         rambo(I):=uvect;
      end loop;
      return rambo;
    end function;

    shared variable ram1 : ram_array := ram_file_init(init_file);

  -- Signal Declarations
--  type ram_array is array (2**adr_width-1 downto 0) of unsigned(dat_width-1 downto 0);
--  shared variable ram1 : ram_array;

begin

process (clk_a)
begin
   if (clk_a'event and clk_a='1') then
      if (en_a_i='1') then
         if (we_a_i='1') then
           ram1(to_integer(adr_a_i)) := dat_a_i;
           dat_a_o <= dat_a_i;
         else
           dat_a_o <= ram1(to_integer(adr_a_i));
         end if;
      end if;
   end if;
end process;

end beh;

------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

library work;
use work.convert_pack.all;

entity block_ram_sp is
    generic(
      adr_width      : integer := 7;
      dat_width      : integer := 8
    );
    port (     
       clk_a         : in  std_logic;

       adr_a_i       : in  unsigned(adr_width-1 downto 0);

       we_a_i        : in  std_logic;
       en_a_i        : in  std_logic;
       dat_a_i       : in  unsigned(dat_width-1 downto 0);
       dat_a_o       : out unsigned(dat_width-1 downto 0)
    );
end block_ram_sp;

architecture beh of block_ram_sp is

  -- Constants

  -- Signal Declarations
  type ram_array is array (2**adr_width-1 downto 0) of unsigned(dat_width-1 downto 0);
  shared variable ram1 : ram_array;

begin

process (clk_a)
begin
   if (clk_a'event and clk_a='1') then
      if (en_a_i='1') then
         if (we_a_i='1') then
            ram1(to_integer(adr_a_i)) := dat_a_i;
         end if;
         dat_a_o <= ram1(to_integer(adr_a_i));
      end if;
   end if;
end process;


end beh;


