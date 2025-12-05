// Author: Claude
// drgonzales@g.hmc.edu
// This function has the purpose of turning off and on an LED based on a HSOSC
// 9/2/25

module led_blinker (
    output logic led
);

    // Internal oscillator clock signal
    logic clk_48mhz;
    
    // Counter for frequency division
    // 48MHz / 2Hz = 24M counts per half period
    // Need 25 bits to count up to 24M (2^25 = 33.5M)
    logic [24:0] counter;
    
    // LED state register
    logic led_state;
    
    // Instantiate the internal high-frequency oscillator
    // HFOSC primitive for UP5K - runs at 48 MHz
    SB_HFOSC #(
        .CLKHF_DIV("0b00")  // No division, full 48 MHz
    ) hfosc_inst (
        .CLKHFPU(1'b1),     // Power up the oscillator
        .CLKHFEN(1'b1),     // Enable the oscillator
        .CLKHF(clk_48mhz)   // 48 MHz output clock
    );
    
    // Calculate the count needed for 2 Hz toggle (1 Hz blink)
    // 48,000,000 / 4 = 12,000,000 counts per quarter period
    // This gives us 2 Hz toggle rate (1 Hz visible blink)
    localparam logic [24:0] TOGGLE_COUNT = 25'd12_000_000;
    
    // Counter and LED control logic
    always_ff @(posedge clk_48mhz) begin
        if (counter >= TOGGLE_COUNT - 1) begin
            counter <= '0;              // Reset counter using SystemVerilog syntax
            led_state <= ~led_state;    // Toggle LED state
        end else begin
            counter <= counter + 1'b1;
        end
    end
    
    // Output assignment
    assign led = led_state;
    
endmodule