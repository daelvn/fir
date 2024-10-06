---# examples.testable #---
-- Example document to generate tests and documentation from them

--# main #--

--- @function id :: a -> a
--- Identity function
--
-- ?? 2 == id 1
export id = (a) -> a

--- @function map :: (a -> b) -> [a] -> [b]
--- Map function
--
-- !! array = { 1, 2, 3 }
-- ??~ ((map id) array), array
export map = (fn) -> (l) -> [fn a for a in *l]
