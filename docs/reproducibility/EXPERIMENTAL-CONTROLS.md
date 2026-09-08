# Research Council Experimental Controls

## Purpose

This document defines the variables that must be controlled or recorded for future Research Council experiments.

The reproducibility review demonstrated that model identity and source code alone are insufficient to reproduce institutional behavior.

## Experimental Identity

Record:

- git commit
- branch or tag
- architecture version
- benchmark harness revision

## Model Configuration

Record:

- provider
- model identifier
- model revision or digest when available
- runtime configuration

## Benchmark Input

Record:

- exact research question
- role prompts
- system instructions
- evaluation criteria

## Institutional Structure

Record:

- available roles
- role ordering
- workflow execution path
- aggregation method
- decision mechanisms

## Memory State

Record:

- knowledge database snapshot
- retrieval context
- relevant entries available to agents
- before and after memory state when applicable

## Environment State

Record:

- operating system
- runtime environment
- filesystem assumptions
- configuration variables
- external dependencies

## Artifact Preservation

Preserve:

- generated outputs
- execution logs
- intermediate reasoning artifacts
- run metadata

## Principle

A cognitive system is defined not only by its underlying model, but by the interaction between model, institutional structure, memory, retrieval, and environment.
