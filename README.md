# Network Connection Troubleshooting Expert System

## 1. Project Overview

This project is developed for the BAI31123 Knowledge Representation Group Project at Raffles University.

The Network Connection Troubleshooting Expert System is a rule-based system developed by using Prolog to identify the common network connection problems based on the user responses. It provides diagnoses, explanations and suggested troubleshooting actions.

## 2. System Features

- 14 predefined diagnostic questions
- 16 middle-layer rules
- 8 diagnosis clauses, including the unknown fallback
- Conditional questioning
- Record the answers to avoid asking the same question again
- Automatic network problem diagnosis
- Explanation and troubleshooting recommendations
- Input validation
- Unknown case handling

## 3. Diagnosis Outcomes

The system supports 8 possible outcomes:

1. Wi-Fi Disabled
2. Weak Wi-Fi Signal
3. IP Configuration Problem
4. DNS Problem
5. Router Problem
6. ISP Outage
7. Cable Connection Problem
8. Unknown Network Problem

## 4. System Architecture

The system is organised into four knowledge layers:

- Layer 1: Question and Answer Management
- Layer 2: Middle-Layer Rules
- Layer 3: Diagnosis Rules
- Layer 4: Explanation and Advice

## 5. Technologies Used

- Prolog
- SWI-Prolog Online (SWISH)
- GitHub

## 6. How to Run

1. Download the `network_expert_system.pl` file.
2. Open SWI-Prolog Online (SWISH): https://swish.swi-prolog.org/
3. Copy the source code into the program editor.
4. Enter the following query:

   ```prolog
   start.
   ```

5. Click the Run button.
6. Answer the questions using `yes`, `no`, or `unknown` in lowercase.
7. View the diagnosis and suggested troubleshooting action.
8. Enter `why` when prompted to view the explanation and recorded answers or `exit` to finish.

## 7. System Limitations

- The system relies on user-reported symptoms.
- Only the first matching diagnosis is returned.
- Device-specific Wi-Fi detection failures are not
  specifically diagnosed.
- Multiple simultaneous network problems may not
  be fully identified.

## 8. Group Members

### Member 1 - [Abbie Song] ([BAI_A2009F-2605003])

- Knowledge base development
- Diagnostic question design
- Middle-layer rules
- Diagnosis rule implementation
- System testing and report preparation

### Member 2 - [Goh Tse Thing] ([BAI_A2009F-2605002])

- User interaction mechanism
- Answer memory and input validation
- Additional diagnosis rules
- Explanation and advice mechanism
- System testing and report preparation

## 9. AI Usage Declaration

ChatGPT was used to assist with project planning, code debugging and test case preparation. The group members reviewed, adapted and integrated the suggested code.

## 10. Academic Purpose

This project is developed for academic purposes as part of the BAI31123 Knowledge Representation course at Raffles University.
