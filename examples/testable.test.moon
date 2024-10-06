---# Tests for examples.testable #---
-- This test suite was automatically generated from documentation comments,
-- the tests are embedded in the code itself. Do not edit this file.
assert = require 'luassert'
M = require 'examples.testable'
setmetatable _ENV, {['__index']: M}

--///--
-- argument and tag initialization
args, tags = {...}, {}
for _, v in ipairs args do tags[v] = true
--///--
print 'TAP version 14'
print '1..2'
--///--
-- counters
FIR_SUCCESSES, FIR_FAILURES, FIR_PENDINGS = 0, 0, 0
-- incrementing functions
FIR_SINCR, FIR_FINCR, FIR_PINCR = (() -> FIR_SUCCESSES = FIR_SUCCESSES + 1), (() -> FIR_FAILURES = FIR_FAILURES + 1), (() -> FIR_PENDINGS = FIR_PENDINGS + 1)
-- other functions
FIR_SUCCEED = (current, count) -> print 'ok ' .. count .. ' - ' .. current
FIR_FAIL = (current, count, err) -> print 'not ok ' .. count .. ' - ' .. current .. ': ' .. (string.gsub err, '[\r\n]+', '')
FIR_PEND = (current, count) -> print 'not ok ' .. count .. ' - ' .. current .. ' # SKIP'
FIR_RESULT = (current) -> 
-- marker for pending tests
FIR_NEXT_PENDING = false
--///--

--# General #--
-- Tests for the whole file are placed here.

--# main #--
-- Tests for main.

--- @test main#1
--- Test for element main #1
-- - **Type:** `test`
--:moon Test
--  2 == id 1
xpcall (() -> 
  if FIR_NEXT_PENDING
    FIR_PINCR!
    FIR_NEXT_PENDING = false
    FIR_PEND 'main#1', '1'
    return
  assert.truthy 2 == id 1
  FIR_SUCCEED 'main#1', '1'
  FIR_SINCR!
), ((err) -> 
  FIR_FAIL 'main#1', '1', err
  FIR_FINCR!
)

array = { 1, 2, 3 }
--- @test main#2
--- Test for element main #2
-- - **Type:** `luassert-test` (same)
--:moon Test
--  ((map id) array), array
xpcall (() -> 
  if FIR_NEXT_PENDING
    FIR_PINCR!
    FIR_NEXT_PENDING = false
    FIR_PEND 'main#2', '2'
    return
  assert.same ((map id) array), array
  FIR_SUCCEED 'main#2', '2'
  FIR_SINCR!
), ((err) -> 
  FIR_FAIL 'main#2', '2', err
  FIR_FINCR!
)

--# `id`

--# `map`

FIR_RESULT!