# Loan service for students (who go to University)
## Concept
### Issue
- if students go to school which is especially University, students who can borrow enough money or access to student loan is less.

- Currently, student loan is expensive for many students. Therefore, there are many students who can't repay loan after they graduate


### Solution
1. Publish Student Loan Token (SLT)
2. Convert from SLT to DAI
3. Borrower who is a student borrow DAI from Lender
(credit score is not only traditional items, but also include reputation based items)


## Setup & Run
```
$ npm run client （"cd client && npm run start"）

$ npm run console （"truffle console --network development"）

$ npm run session （"zos session --network development --expires 7200"）
```
Another scripts is also written in package.json



## MakerDAO Testchain
if it work on local environment, it execute MakerDAO Testchain.
```
$ cd /path/Testchain
$ scripts/launch -s default --fast
```
https://github.com/makerdao/testchain/tree/dai.js

