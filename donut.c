#include <stdio.h>
#include <string.h>
#include <math.h>

// Screen dimensions
#define SCREEN_WIDTH 80
#define SCREEN_HEIGHT 22

int main() {
    // Rotation angles
    float angleA = 0.0f;
    float angleB = 0.0f;

    // Output and depth buffers
    char output[SCREEN_WIDTH * SCREEN_HEIGHT];
    float zBuffer[SCREEN_WIDTH * SCREEN_HEIGHT];

    // Clear screen
    printf("\x1b[2J");

    while (1) {
        // Fill buffers with default values
        memset(output, ' ', SCREEN_WIDTH * SCREEN_HEIGHT);
        memset(zBuffer, 0, SCREEN_WIDTH * SCREEN_HEIGHT * sizeof(float));

        // 3D donut loop
        for (float theta = 0; theta < 2 * M_PI; theta += 0.07f) {
            for (float phi = 0; phi < 2 * M_PI; phi += 0.02f) {
                // 3D coordinate calculations
                float sinTheta = sin(theta);
                float cosTheta = cos(theta);
                float sinPhi = sin(phi);
                float cosPhi = cos(phi);

                float sinA = sin(angleA);
                float cosA = cos(angleA);
                float sinB = sin(angleB);
                float cosB = cos(angleB);

                // Donut shape and rotation math
                float circleX = cosTheta + 2; // R1 + R2*cos(theta)
                float circleY = sinTheta;

                float x = circleX * (cosB * cosPhi + sinA * sinB * sinPhi) - circleY * cosA * sinB;
                float y = circleX * (sinB * cosPhi - sinA * cosB * sinPhi) + circleY * cosA * cosB;
                float z = 5 + cosA * circleX * sinPhi + circleY * sinA;
                float ooz = 1.0f / z;  // "One over z"

                // Projection to 2D screen
                int screenX = (int)(SCREEN_WIDTH / 2 + 30 * ooz * x);
                int screenY = (int)(SCREEN_HEIGHT / 2 - 15 * ooz * y);
                int index = screenX + SCREEN_WIDTH * screenY;

                // Luminance calculation
                float luminance = cosPhi * cosTheta * sinB - cosA * cosTheta * sinPhi -
                                  sinA * sinTheta + cosB * (cosA * sinTheta - cosTheta * sinA * sinPhi);

                int luminanceIndex = (int)(luminance * 8);

                // Update buffers if pixel is visible
                if (screenX >= 0 && screenX < SCREEN_WIDTH &&
                    screenY >= 0 && screenY < SCREEN_HEIGHT &&
                    ooz > zBuffer[index]) {

                    zBuffer[index] = ooz;

                    // ASCII characters for shading
                    const char *brightness = ".,-~:;=!*#$@";
                    output[index] = brightness[luminanceIndex > 0 ? luminanceIndex : 0];
                }
            }
        }

        // Print frame
        printf("\x1b[H"); // Move cursor to top-left
        for (int i = 0; i < SCREEN_WIDTH * SCREEN_HEIGHT; i++) {
            putchar(i % SCREEN_WIDTH ? output[i] : '\n');
        }

        // Rotate donut
        angleA += 0.04f;
        angleB += 0.02f;
    }

    return 0;
}
