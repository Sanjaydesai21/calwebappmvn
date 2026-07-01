package com.cruds.test;

import static org.junit.Assert.*;

import org.junit.Test;

import com.cruds.service.CalculatorService;

public class TestCalculatorService {

	@Test
	public void testAdd() {
		assertEquals(10, CalculatorService.add(5, 5));
	}

	@Test
	public void testNull() {
		assertEquals(0, CalculatorService.add(0,0));
	}

}
