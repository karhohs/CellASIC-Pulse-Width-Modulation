<?xml version="1.0" encoding="utf-8"?>
<RxPWM_config>
<info>
    <plateType>M04S</plateType>
</info>
<pulseWidth units="minutes" value="0.006"></pulseWidth>
<!-- The recommended psi is 2 -->
<psi>2</psi>
<!-- The M04S plate has 6 columns of inlet wells, 4 wells per column, that interface with pressure valves in the ONIX system. PWM requires the use of two valves (columns). The column with the maximum concentration of drug contains the value 1. The column with the minimum concentration of drug contains the value 0. The columns that will not be used for PWM will be left empty. Note that valves (columns) 1 and 6 are not part of this configuration file. These are the so-called "gravity wells" that flow liquid when the plate is not connected to the ONIX manifold. If pressure is applied to columns 1 or 6 they will be drained rapidly. -->
<valve_2>1</valve_2>
<valve_3>0</valve_3>
<valve_4></valve_4>
<valve_5></valve_5>
</RxPWM_config>