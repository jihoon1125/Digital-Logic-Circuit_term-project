# Digital-Logic-Circuit_term-project
Factorial , RAM hardware 그리고 direct memory access controller (DMAC)를 설계하고, bus를 통해 이들을 연결하여 검증과정까지 수행한다.

---

## Project goals
*	Multiplier를 구현했던 경험으로 더 성능이 좋은 module의 design과 factorial 구현 방법에 대해서 깊게 생각해본다.
*	전체적인 bus 동작의 이해 및 DMAC, RAM, testbench, factorial 간의 유기적인 동작 순서를 깨닫고, 프로그램의 대형화에 대처하는 꼼꼼함을 기른다.
*	매우 복잡하게 동작하는 프로그램을 만들었을 때 정확성을 test하기 위해 정확하고 효율적인 verification 전략을 설계해본다.
*	이전까지 구현했던 모든 실습시간에서의 module을 사용해 봄으로써 배웠던 것을 전부 실용적인 설계에 투입한다.
*	혹시나 나중에 더 큰 프로그램을 설계할 때에도 두려움을 갖지 않고 차근차근 해결해 나갈 수 있는 침착함과 꼼꼼함을 기른다.


---

## System Overview

![image](https://user-images.githubusercontent.com/67624104/118246400-e0aa6400-b4dc-11eb-8985-a2166ba9803f.png)

* 전체 시스템의 구성 요소는 크게 4가지로 DMAC, FACTORIAL, BUS, RAM그리고 testbench이다.
* 본 시스템은 testbench로부터 MEMORY에 M개의 N-value(0 < N-value < 21)를 저장한다. Testbench에서 DMAC에게 op_start signal을 보내주면, DMAC는 MEMORY에 저장된 값을 설정된 opmode에 따라 FACTORIAL로 전송해준다. 이때 DMAC가 master가 된다.
* FACTORIAL은 전송 받은 값을 내부에 있는 factorial_FIFO에 저장한다. DMAC interrupt signal이 발생하게 되면, testbench는 다시 bus master가 되어 FACTORIAL에게 op_start signal을 보낸다. * FATORIAL은 FIFO에 있는 N-value값을 POP하여 FIFO가 empty가 될 때까지 factorial 연산을 수행하고, FACTORIAL 내부에 있는 R_FIFO에 연산 결과를 result[63:32], result[31:0]순서대로 2 cycle에 걸쳐 값을 써 넣어주게 된다. FACTORIAL interrupt signal 이 발생하게 되면, testbench는 다시 bus master가 되어, result값을 MEMORY에 써 넣어 주기 위해 opmode를 설정하고, DMAC에게 op_start signal을 보낸다. 
* DMAC는 설정된 opmode에 따라 FACTORIAL의 result RF값을 MEMORY로 전송하고 완료되면, DMAC interrupt signal을 발생하게 된다.
* BUS는 수업 중 설계한 simple bus를 이용한다. BUS를 통해 block간 주고 받을 수 있는 정보는 address와 data 그리고 read/write 명령뿐이다. 따라서 hardware block들 간에 다양한 명령을 주고 받기 위해서는 미리 약속된 값들을 register (flip-flop array)라고 하는 특별한 공간에 쓰고 읽어야 한다. 예를 들어, DMAC block에게 연산을 시작하도록 하기 위해서는 OPERATION START register 에 0x1 값을 써야한다. 또한 이러한 register들을 선택하기 위해서는 address를 이용한다. 즉, memory-mapped IO방식으로 register들을 addressing하게 된다. 따라서, 각 block들의 register들은 offset address를 갖고 있다.

---


## Design details

 ### RAM

 ![image](https://user-images.githubusercontent.com/67624104/118246593-22d3a580-b4dd-11eb-8008-a7d30cdc1008.png)

 ### BUS

![image](https://user-images.githubusercontent.com/67624104/118246987-9ecded80-b4dd-11eb-9fde-045d37b2a7ed.png)


  * Arbiter FSM

  ![image](https://user-images.githubusercontent.com/67624104/118247654-61b62b00-b4de-11eb-99c5-2de38d085e26.png)

    * Reset시 M0 grant 허가
    * M0_req, M1_req 둘 다 0이거나 M0_req가 1일 때 계속 M0 grant 유지
    * M0 grant일 때 M1_req가 1, M0_req가 0이 되면 M1 grant로 이동
    * M1 grant일 때 M1_req가 1 이거나 M0_req, M1_req가 모두 0이면 M1 grant 유지
    * M1 grant일 때 M1_req가 0이고 M0_req가 1이면 M0 grant로 이동



 ### DMAC

![image](https://user-images.githubusercontent.com/67624104/118247955-b9ed2d00-b4de-11eb-9e2c-560239cd72bb.png)


* FSM

![image](https://user-images.githubusercontent.com/67624104/118249237-27e62400-b4e0-11eb-8771-04683a1b6eb4.png)
 
  * IDLE: Testbench master state
  * FIFO_POP: DMAC 내부의 FIFO에서 descriptor pop 해서 가져옴, 값 가져왔으면 BUS_REQ로 이동
  * BUS_REQ: M_req를 1로 출력, bus로부터 master권한 허락받아 M_grant가 1이 되면 MEM_READ로 이동
  * MEM_READ: source address의 주소값 read 후 MEM_WRITE로 이동
  * MEM_WRITE: M_dout으로 write 후 data size가 0보다 크면 MEM_READ로, data size가 0이고 count가 0보다 크면 FIFO_POP, 둘 다 아니면 DONE으로 이동
  * DONE: 동작완료를 의미하는 interrupt signal 출력, op_clear신호 들어오면 IDLE state로 이동



### FACTORIAL

**내부 곱셈연산은 4-radix booth multiplier submodule로 구현, submodule 설명은 생략한다**

![image](https://user-images.githubusercontent.com/67624104/118251971-32ee8380-b4e3-11eb-9127-ac2915eca2af.png)


* FSM

![image](https://user-images.githubusercontent.com/67624104/118252011-3eda4580-b4e3-11eb-9a81-021cd1956581.png)

  * IDLE: reset시 state, DMAC으로부터 N-value들을 N_FIFO에 저장하고 내부 register 값을 setting한다. 만약 N_FIFO의 empty signal이 0이고 op_start가 1이면 N_FIFO_POP으로 이동
  * N_FIFO_POP: N_FIFO에서 값을 pop 해온다. 그 뒤에는 factorial execution state로 이동
  * FACTORIAL execution, R_FIFO_PUSH_1, 2: 연산의 종료를 의미하는 fac_op_done이 1이 될 때까지 연산진행 후 완료 되면 결과값 64bit를 두개의 32bit 값으로 나누어 R_FIFO에 push한다. R_FIFO read조건이 충족되면 즉시 MEM_WRITE_1 state로 이동한다. 충족되지 않았으면 STOP state에서 대기
  * MEM_WRITE_1,2 : 상위 32bit, 하위 32bit 값들을 S_dout으로 출력



### TOP

![image](https://user-images.githubusercontent.com/67624104/118253892-6df1b680-b4e5-11eb-8cb5-06a23cb2a677.png)

---


## Verification

* Verification_starategy.pdf 파일 참조

  
