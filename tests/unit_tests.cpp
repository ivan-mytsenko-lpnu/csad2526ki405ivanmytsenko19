#include "math_operations.h"
#include <gtest/gtest.h>

TEST(AddFunction, PositiveNumbers) {
    EXPECT_EQ(add(2, 3), 5);
}

TEST(AddFunction, NegativeNumbers) {
    EXPECT_EQ(add(-2, -3), -5);
}

TEST(AddFunction, MixedSign) {
    EXPECT_EQ(add(-2, 3), 1);
}

TEST(AddFunction, Zero) {
    EXPECT_EQ(add(0, 0), 0);
}