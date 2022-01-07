exename=impCalc

SRC_DIR := src
OBJ_DIR := obj
BIN_DIR := bin


#name final target
EXE := $(BIN_DIR)/$(exename)

#get source files
SRC := $(wildcard $(SRC_DIR)/*.cpp)

#get obj files using source files
OBJ := $(patsubst $(SRC_DIR)/%.cpp, $(OBJ_DIR)/%.o, $(SRC))

#flags
#C Pre-Processor Flags
#-MMD -MP generate header dependencies automatically (used later to trigger compilation only if a header changes)
CPPFLAGS :=-Iinclude -MMD -MP 
CXXFLAGS :=-Wall -Wextra
LDFLAGS  :=
LDLIBS   :=-lncurses


.PHONY: clean
.PHONY: all


all: $(EXE)

#check $BIN_DIR then run this rule
#note: CPPFLAGS and CXXFLAGS are useless here, this is the linking phase, compilation aleady happend
$(EXE): $(OBJ) | $(BIN_DIR)
	$(CXX) $(LDFLAGS) $^ $(LDLIBS) -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp | $(OBJ_DIR)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@

$(BIN_DIR) $(OBJ_DIR):
	mkdir -p $@

clean: 
	@$(RM) -rv $(BIN_DIR) $(OBJ_DIR) # the at prevents this line from being echo'd


#Use header dependencies
-include $(OBJ:.o=.d) #The dash is used to silence errors if the files don't exist yet
