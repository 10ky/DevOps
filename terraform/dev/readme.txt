Naming Convention
-----------------
There is a 32 character name length limit to AWS resources, the stage name usually is used as part of a resource name, for this reason, stage name convention is 7 characters in length in the form of <stage><filling digits>.  For example: prod001, poc0001, or qa00001.  This provides uniformaty in names as to avoid triggering terraform application error due to name length out of range problem.
