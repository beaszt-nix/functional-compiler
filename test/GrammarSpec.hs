module GrammarSpec
where

import Test.Hspec
import Tokens
import Grammar

grammarSpec :: IO ()
grammarSpec = hspec $ do
  describe "Grammar" $ do
    it "Returns an int" $ do
      let tokens = [TokenInt 123, TokenNewLine]
      let expectedStructure = [Tok (Int 123)]
      parseTokenss tokens `shouldBe` expectedStructure

    it "Returns a var" $ do
      let tokens = [TokenSym "abc", TokenNewLine]
      let expectedStructure = [Tok (Sym "abc")]
      parseTokenss tokens `shouldBe` expectedStructure
      
    it "Returns a variable assignment" $ do
      let tokens = [TokenVar, TokenSym "abc", TokenAssign, TokenInt 3, TokenNewLine]
      let expectedStructure = [Assign "abc" (Int 3)]
      parseTokenss tokens `shouldBe` expectedStructure

    it "Returns a calculation (sum multiply)" $ do
      let tokens = [TokenInt 3, TokenPlus, TokenInt 4, TokenMultiply, TokenInt 5, TokenNewLine]
      let expectedStructure = [Tok (Plus (Int 3) (Multiply (Int 4) (Int 5)))]
      parseTokenss tokens `shouldBe` expectedStructure
    
    it "Returns a calculation (minus divide)" $ do
      let tokens = [TokenInt 3, TokenDivide, TokenInt 4, TokenMinus, TokenInt 5, TokenNewLine]
      let expectedStructure = [Tok (Minus (Divide (Int 3) (Int 4)) (Int 5))]
      parseTokenss tokens `shouldBe` expectedStructure

    it "Returns an if condition" $ do
      let tokens = [TokenIf, TokenInt 3, TokenLess, TokenInt 4, TokenNewLine, TokenInt 3, TokenNewLine, TokenEndIf, TokenNewLine]
      let expectedStructure = [IfExp (If (Less (Int 3) (Int 4)) [Tok (Int 3)])]
      parseTokenss tokens `shouldBe` expectedStructure
    
    it "Returns a print statement" $ do
      let tokens = [TokenPrint,TokenSym "a",TokenNewLine]
      let expectedStructure = [Print (Sym "a")]
      parseTokenss tokens `shouldBe` expectedStructure

    it "Returns an ifelse condition" $ do
      let tokens = [TokenIf, TokenInt 3, TokenLess, 
                    TokenInt 4, TokenNewLine, TokenInt 4,
                    TokenNewLine, TokenElse, TokenNewLine,
                    TokenInt 4, TokenNewLine, TokenEndIf, 
                    TokenNewLine]

      let expectedStructure = [IfExp (IfElse (Less (Int 3) (Int 4)) [Tok (Int 4)] [Tok (Int 4)])]
      parseTokenss tokens `shouldBe` expectedStructure