\ adc.4th -- Analog-to-Digital Converter

$4003B000 constant ADC0_SC1A  \ ADC Status and Control Registers 1
$4003B004 constant ADC0_SC1B  \ ADC Status and Control Registers 1
$4003B008 constant ADC0_CFG1  \ ADC Configuration Register 1
$4003B00C constant ADC0_CFG2  \ ADC Configuration Register 2
$4003B010 constant ADC0_RA    \ ADC Data Result Register
$4003B014 constant ADC0_RB    \ ADC Data Result Register
$4003B018 constant ADC0_CV1   \ Compare Value Registers
$4003B01C constant ADC0_CV2   \ Compare Value Registers
$4003B020 constant ADC0_SC2   \ Status and Control Register 2
$4003B024 constant ADC0_SC3   \ Status and Control Register 3
$4003B028 constant ADC0_OFS   \ ADC Offset Correction Register
$4003B02C constant ADC0_PG    \ ADC Plus-Side Gain Register
$4003B030 constant ADC0_MG    \ ADC Minus-Side Gain Register
$4003B034 constant ADC0_CLPD  \ ADC Plus-Side General Calibration Value Register
$4003B038 constant ADC0_CLPS  \ ADC Plus-Side General Calibration Value Register
$4003B03C constant ADC0_CLP4  \ ADC Plus-Side General Calibration Value Register
$4003B040 constant ADC0_CLP3  \ ADC Plus-Side General Calibration Value Register
$4003B044 constant ADC0_CLP2  \ ADC Plus-Side General Calibration Value Register
$4003B048 constant ADC0_CLP1  \ ADC Plus-Side General Calibration Value Register
$4003B04C constant ADC0_CLP0  \ ADC Plus-Side General Calibration Value Register
$4003B050 constant ADC0_PGA   \ ADC PGA Register
$4003B054 constant ADC0_CLMD  \ ADC Minus-Side General Calibration Value Register
$4003B058 constant ADC0_CLMS  \ ADC Minus-Side General Calibration Value Register
$4003B05C constant ADC0_CLM4  \ ADC Minus-Side General Calibration Value Register
$4003B060 constant ADC0_CLM3  \ ADC Minus-Side General Calibration Value Register
$4003B064 constant ADC0_CLM2  \ ADC Minus-Side General Calibration Value Register
$4003B068 constant ADC0_CLM1  \ ADC Minus-Side General Calibration Value Register
$4003B06C constant ADC0_CLM0  \ ADC Minus-Side General Calibration Value Register
$400BB000 constant ADC1_SC1A  \ ADC Status and Control Registers 1
$400BB004 constant ADC1_SC1B  \ ADC Status and Control Registers 1
$400BB008 constant ADC1_CFG1  \ ADC Configuration Register 1
$400BB00C constant ADC1_CFG2  \ ADC Configuration Register 2
$400BB010 constant ADC1_RA    \ ADC Data Result Register
$400BB014 constant ADC1_RB    \ ADC Data Result Register
$400BB018 constant ADC1_CV1   \ Compare Value Registers
$400BB01C constant ADC1_CV2   \ Compare Value Registers
$400BB020 constant ADC1_SC2   \ Status and Control Register 2
$400BB024 constant ADC1_SC3   \ Status and Control Register 3
$400BB028 constant ADC1_OFS   \ ADC Offset Correction Register
$400BB02C constant ADC1_PG    \ ADC Plus-Side Gain Register
$400BB030 constant ADC1_MG    \ ADC Minus-Side Gain Register
$400BB034 constant ADC1_CLPD  \ ADC Plus-Side General Calibration Value Register
$400BB038 constant ADC1_CLPS  \ ADC Plus-Side General Calibration Value Register
$400BB03C constant ADC1_CLP4  \ ADC Plus-Side General Calibration Value Register
$400BB040 constant ADC1_CLP3  \ ADC Plus-Side General Calibration Value Register
$400BB044 constant ADC1_CLP2  \ ADC Plus-Side General Calibration Value Register
$400BB048 constant ADC1_CLP1  \ ADC Plus-Side General Calibration Value Register
$400BB04C constant ADC1_CLP0  \ ADC Plus-Side General Calibration Value Register
$400BB050 constant ADC1_PGA   \ ADC PGA Register
$400BB054 constant ADC1_CLMD  \ ADC Minus-Side General Calibration Value Register
$400BB058 constant ADC1_CLMS  \ ADC Minus-Side General Calibration Value Register
$400BB05C constant ADC1_CLM4  \ ADC Minus-Side General Calibration Value Register
$400BB060 constant ADC1_CLM3  \ ADC Minus-Side General Calibration Value Register
$400BB064 constant ADC1_CLM2  \ ADC Minus-Side General Calibration Value Register
$400BB068 constant ADC1_CLM1  \ ADC Minus-Side General Calibration Value Register
$400BB06C constant ADC1_CLM0  \ ADC Minus-Side General Calibration Value Register

0 constant ADC_0
1 constant ADC_1
2 constant ADC_BOTH



: adc_ref_set ( num_avgs=0|4|8|16|32 adc_num=0|1|2  -- )
 ;

: adc_readres_set ( num_avgs=0|4|8|16|32 adc_num=0|1|2  -- )
 ;

: adc_averaging_set ( num_avgs=0|4|8|16|32 adc_num=0|1|2  -- )
  $7 ADC0_SC3 bis! \ SC3[AVGE]=1 and SC3[AVGS]=11 for an average of 32SC3[AVGE]=1 and SC3[AVGS]=11 for an average of 32
 ;

: adc_clk_set \ Set ADC clock frequency f ADCK less than or equal to 4 MHz
  1 3 lshift ADC0_CFG2 bis!
  $3 ADC0_CFG1 bis! \ ADACK set
  \ TODO clk divider???
 ;



: +adc_calibrate
  \ Configure calibration
  adc_averaging_set
  adc_clk_set
  \ V_REFH=V_DDA
  
  \ Initiate calibration
  1 7 lshift SC3 bis! \ begin calibration
 ;

: -adc_calibrate
 ;

\ p692 of K20P64M72SF1RM.pdf (datasheet)
: adc_init ( 0|1|2 -- )
  \ Calibrate ADC
 ;

: adc@
 ;



