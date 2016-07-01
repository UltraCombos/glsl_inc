#version 430 core

#define TWO_PI 6.28318530717958647693

uniform mat4 viewMatrix;
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 modelViewProjectionMatrix;

uniform float uDeltaTime;
uniform float uElapseTime;
uniform float uTimeValue;
uniform vec3 uCameraPosition;
uniform int uSides;
uniform float uSpriteSize;
uniform int uNumParticles;
uniform float uNoiseScale;
uniform float uNoiseStrength;
uniform float uPullStrength;
uniform float uMoveRatio;