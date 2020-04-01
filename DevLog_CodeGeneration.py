outputSpecName = "DevLog_CodeGeneration_spec.txt"
outputBodyName = "DevLog_CodeGeneration_body.txt"
outputSpec = open(outputSpecName, "w")
outputBody = open(outputBodyName, "w")

logPatternA = '''procedure log(
'''

logPatternB = '''  psText6  in varchar2 default null,
  psText7  in varchar2 default null,
  psText8  in varchar2 default null,
  psText9  in varchar2 default null,
  psText10 in varchar2 default null,
  psText11 in varchar2 default null,
  psText12 in varchar2 default null,
  psText13 in varchar2 default null,
  psText14 in varchar2 default null,
  psText15 in varchar2 default null,
  psText16 in varchar2 default null,
  psText17 in varchar2 default null,
  psText18 in varchar2 default null,
  psText19 in varchar2 default null,
  psText20 in varchar2 default null,
  pnDepth  in number   default null)
is
begin
  log('''

logPatternC = '''
      psText6,  psText7,  psText8,  psText9,  psText10,
      psText11, psText12, psText13, psText14, psText15,
      psText16, psText17, psText18, psText19, psText20,
      cnCallerDepth);
end;
'''

def getPatternSpec(noParams):
    paramPlaceholders = "%s" * noParams
    return logPatternA + paramPlaceholders + logPatternB[:-17] + ");\n"

def getPattern(noParams):
    paramPlaceholders = "%s" * noParams
    return logPatternA + paramPlaceholders + logPatternB + paramPlaceholders + logPatternC


def getParamCode(setting, index):
    if setting == "1":
        return "  pbText"+str(index)+"  in boolean,\n"
    return "  psText"+str(index)+"  in varchar2 default null,\n"

def getFuncCode(setting, index):
    lineEndB = "), "
    lineEndV = ",  "
    if index == 5:
        lineEndB = "),"
        lineEndV = ","
    if setting == "1":
        return "tc(pbText"+str(index)+lineEndB
    return "psText"+str(index)+lineEndV

def printCodeSpec(parameters):
    code = getPatternSpec(len(parameters))
    for i,p in enumerate(parameters):
        code = code.replace("%s", getParamCode(p, i+1), 1) # replace only first occurrence
    #print(code)
    outputSpec.write(code)
    
def printCode(parameters):
    code = getPattern(len(parameters))
    for i,p in enumerate(parameters):
        code = code.replace("%s", getParamCode(p, i+1), 1) # replace only first occurrence
    for i,p in enumerate(parameters):
        code = code.replace("%s", getFuncCode(p, i+1), 1) # replace only first occurrence
    print(code)
    outputBody.write(code)

size = 5
combinations = []
for i in range(0, 2**size):
    iBin = bin(i)[2:]
    leftPadding = "0" * (size - len(iBin))
    iBin = leftPadding + iBin
    #print(iBin)
    combinations.append(iBin)
for c in combinations:
    printCodeSpec(c)
    printCode(c)

outputSpec.close()
outputBody.close()
# end
