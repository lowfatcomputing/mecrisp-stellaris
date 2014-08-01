\ dac-dma.4th -- DAC with DMA for higher rates.
\ 
\ REQUIRES: dac.4th delay.4th nvic.4th dac-examples.4th
\ 

$4003600C constant PDB0_IDLY
$4004803C constant SIM_SCGC6
  $400000    constant SIM_SCGC6_PDB
1087      constant PDB_PERIOD
$40036004 constant PDB0_MOD
$40036000 constant PDB0_SC
  $1  constant PDB_SC_LDOK
  $2  constant PDB_SC_CONT
  $80 constant PDB_SC_PDBEN
  $20 constant PDB_SC_PDBIE
\ PDB0_SC     5  portpin: PDB_SC_SWTRIG
$782   constant PDB_CONFIG
$0F00 constant TRGSEL \ 15 Software trigger is selected
  $8000 constant PDB_SC_DMAEN
  $10000 constant PDB_SC_SWTRIG
$40048040 constant SIM_SCGC7
  $2 constant SIM_SCGC7_DMA
$40008000 constant DMA_CR
$40009080 constant DMA_TCD4_SADDR
\ Sign-extended offset applied to the current source address to form the next-state value as each source read is completed.Sign-extended offset applied to the current source address to form the next-state value as each source read is completed.
$40009084 constant DMA_TCD4_SOFF
$40009086 constant DMA_TCD4_ATTR
  $1 constant DMA_TCD4_ATTR_SMOD    \ Loop over sine table continuously??
  $100 constant DMA_TCD4_ATTR_SSIZE \ 16-bit
  $1 constant DMA_TCD4_ATTR_DSIZE   \ 16-bit
$40009088 constant DMA_TCD4_NBYTES_MLNO
$4000908C constant DMA_TCD4_SLAST
$40009090 constant DMA_TCD4_DADDR
$40009094 constant DMA_TCD4_DOFF
$40009096 constant DMA_TCD4_CITER_ELINKNO
$40009098 constant DMA_TCD4_DLASTSGA
$4000909C constant DMA_TCD4_CSR
  $4 constant DMA_TCD_CSR_INTHALF
  $2 constant DMA_TCD_CSR_INTMAJOR
$4000909E constant DMA_TCD4_BITER_ELINKNO
$4000801B constant DMA_SERQ
$40021004 constant DMAMUX0_CHCFG4
0         constant DMAMUX_DISABLE
128       constant DMAMUX_ENABLE
48        constant DMAMUX_SOURCE_PDB
$4004803C constant SIM_SCGC6
  $2 constant SIM_SCGC6_DMAMUX
$4000801  constant DMA_CINT

: dma_ch4_done?
  DMA_TCD4_CSR @ $80 and
 ;


: dma_ch4_active?
  DMA_TCD4_CSR @ $40 and
 ;

: dma_ch4
  \ $4 DMA_CINT cbis!
  ." HELLO"
 ;


: +dac_dma
  +dac

  SIM_SCGC6_PDB                                                SIM_SCGC6 bis!
  $1                                                           PDB0_IDLY   h!
  PDB_PERIOD                                                    PDB0_MOD   h!
  PDB_CONFIG PDB_SC_LDOK or                                      PDB0_SC bis!
  PDB_CONFIG PDB_SC_SWTRIG or PDB_SC_PDBIE or PDB_SC_DMAEN or    PDB0_SC bis!
  SIM_SCGC7_DMA                                                SIM_SCGC7 bis!
  SIM_SCGC6_DMAMUX                                             SIM_SCGC6 bis!
  $0                                                              DMA_CR    !
  sine-table                                              DMA_TCD4_SADDR    !
  $2                                                       DMA_TCD4_SOFF   h!
  DMA_TCD4_ATTR_SSIZE DMA_TCD4_ATTR_DSIZE or               DMA_TCD4_ATTR   h!
  $2                                                DMA_TCD4_NBYTES_MLNO    !
  $400 negate                                             DMA_TCD4_SLAST    !
  DAC0_DAT0L                                              DMA_TCD4_DADDR    !
  $0                                                       DMA_TCD4_DOFF   h!
  $400                                            DMA_TCD4_CITER_ELINKNO   h!
  $0                                                   DMA_TCD4_DLASTSGA    !
  $400                                            DMA_TCD4_BITER_ELINKNO   h!
  DMA_TCD_CSR_INTHALF DMA_TCD_CSR_INTMAJOR or               DMA_TCD4_CSR   h!
  DMAMUX_DISABLE                                          DMAMUX0_CHCFG4   c!
  DMAMUX_SOURCE_PDB DMAMUX_ENABLE or                      DMAMUX0_CHCFG4   c!
  \ update_responsibility = update_setup();
  $4                                                            DMA_SERQ   c!
  \ NVIC_ENABLE_IRQ(IRQ_DMA_CH4);
  $4 irq-enable  \ DMA_CH4
  ['] dma_ch4 irq-dma_ch4 !
 ;


: dac_dma_start
  1                                                         DMA_TCD4_CSR bis!
 ;

