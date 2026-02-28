package com.example.demo;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;

public class HelloControllerTest {

    @Test
    void testHome() {
        HelloController controller = new HelloController();
        assertEquals("Hello DevOps Engineer 🚀", controller.home());
    }
}