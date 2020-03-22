outputFileName = "DevLogCodeGeneration_output.txt"

def getPattern(noParams):
    params = ", %s" * noParams
    return "my func (" + params[2:] + ") body " + params[2:]

def getParamCode(setting):
    if setting == "1":
        return "on"
    return "off"

def getFuncCode(setting):
    if setting == "1":
        return "on1"
    return "off1"

def printCode(parameters):
    code = getPattern(len(parameters))
    for size,p in enumerate(parameters):
        code = code.replace("%s", getParamCode(p), 1) # replace only first occurrence
    for p in parameters:
        code = code.replace("%s", getFuncCode(p), 1) # replace only first occurrence
    print(code)

size = 5
combinations = []
for i in range(0, 2**size):
    iBin = bin(i)[2:]
    leftPadding = "0" * (size - len(iBin))
    iBin = leftPadding + iBin
    #print(iBin)
    combinations.append(iBin)
for c in combinations:
    printCode(c)
# end
