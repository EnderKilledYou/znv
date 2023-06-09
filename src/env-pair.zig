

pub const EnvPairError = error {
    KeyStartedWithNumber,
    InvalidKeyCharacter,
};

pub const EnvValueCounter = struct {

 openBraces :u8 = 0,
 closeBraces :u8 = 0,
};

pub const EnvPair = struct {
   const Self = @This();
    key: [32768] u8,
    keyIndex : u8 =0,
    value: [32768] u8,
    valueIndex : u8 = 0,
    interpolation: bool = false,

    fn placeKeyCharacter(self: *Self,value:u8) void {
        // todo: check for overflow and resize array.
        self.key[self.keyIndex] = value;
        self.keyIndex  =self.keyIndex+1;
    }

    pub fn processKeyNextValue(self: *Self,value: u8) !bool {
        if (value == '='){
          //we hit the end
          //todo: shink arrays
          return true;
        }
        if(value == '_'){
            self.placeKeyCharacter(value);
            return false;
        }
        if(value < 'A' )
        {
            return EnvPairError.InvalidKeyCharacter;
        }
        if(value <= 'z'){
            self.placeKeyCharacter(value);
            return false;
        }
        if(value <= '9'){
            if(self.keyIndex != 0){ //can't start with a number
                self.placeKeyCharacter(value);
                return false;
            }
            return EnvPairError.KeyStartedWithNumber;
        }
        return error.InvalidKeyCharacter;
    }
};