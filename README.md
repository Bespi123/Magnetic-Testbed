# Adaptive Controller Approach for a three-axis Helmholtz Magnetic Testbed to test Detumbling Simulations in the GWSAT Satellite
# Introduction
The IS501NMTB magnetic testbed is a platform designed to simulate and analyze magnetic environments for small satellite applications. The testbed utilizes three Helmholtz coils controlled by independent ITECH IT6433 DC power sources and a MAG649L magnetometer. Its primary objectives include:

1. Performing in-the-loop simulations to test detumbling and nadir-pointing attitude control algorithms for the GWSAT mission.
2. Characterizing the magnetic dipole of small satellites using perturbation observers.

The system is modeled mathematically using RL circuits and the Biot-Savart law. This model has been validated with experimental data collected in 2021 and 2024, revealing parameter variations over time. The testbed is also equipped to simulate Earth's magnetic field at the GWSAT orbit using the IGRF-13 model.

To achieve precise control, the platform integrates and tests closed-loop PID, adaptive PID, and MRAC control algorithms. These algorithms are evaluated for their effectiveness in canceling Earth's magnetic field and simulating orbital magnetic conditions. Results are analyzed using error integration and control integration metrics to assess the advantages of adaptive control methods for this application.

---

## Table of Contents

1. [System Architecture](#system-architecture)
2. [Getting Started](#getting-started)
3. [Usage](#usage)
4. [Results and Validation](#results-and-validation)
5. [Contributing](#contributing)
6. [License](#license)

---

## System Architecture

The IS501NMTB testbed consists of:

- **Helmholtz Coils**: Three orthogonal coils to generate uniform magnetic fields.
- **Power Sources**: Independent ITECH IT6433 DC power supplies for precise current control.
- **Magnetometer**: A MAG649L magnetometer for high-resolution field measurements.
- **Control Algorithms**: PID, adaptive PID, and MRAC controllers for dynamic magnetic field simulations.

---

## Getting Started

### Prerequisites

Ensure the following software and hardware are available:

- MATLAB (R2024b or newer)
- Simulink
- Aerospace toolbox
### Installation

Clone the repository:

```bash
git clone https://github.com/Bespi123/Magnetic-Testbed.git
```

---

## Usage

### Running Simulations
#### IS501NMTB EMF simulation
1. Open MATLAB and navigate to the project directory inside `IS501NMTB simulation` folder.
2. To evaluate the 3D magnetic field of the test bed opn `helmholtzSimulation/is501nmtb_simulation.mlx`.
3. To evaluate real data measured in the laboratory open `measuredDataAnalisys/analisysData.mlx` ensuring that folder `data` is include in the path.
#### IS501NMTB close loop simulation
1. Open MATLAB and navigate to the project directory inside `IS501NMTB_closeLoop` folder.
2. Run the simulation parameters `sim_parameters.m` file
7. Run the simulations which are organized inside.
### Playground folder
The playground folder contains auxiliar code used for sensor calibration, data recording and experiments with no relevance to the paper.

### Visualizing Results

- Simulation results, including magnetic field perturbations and control signals, can be visualized using MATLAB scripts included in the repository.
- Example: Use `plotResults.m` to generate performance comparison plots.

---

## Results and Validation

- The mathematical model was validated using experimental data from 2021 and 2024.
- Simulations confirmed the effectiveness of adaptive control algorithms in achieving better performance metrics compared to traditional PID controllers.
- Results are compared using error integration and control effort metrics to evaluate controller efficiency.

---

## Contributing

Contributions are welcome! To contribute:

1. Fork the repository.
2. Create a new feature branch:
   ```bash
   git checkout -b feature-name
   ```
3. Commit changes:
   ```bash
   git commit -m "Add new feature"
   ```
4. Push to the branch:
   ```bash
   git push origin feature-name
   ```
5. Open a pull request.

---

## License

This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for details.

---

## Acknowledgments

Special thanks to Beihang University for the support of this project.
