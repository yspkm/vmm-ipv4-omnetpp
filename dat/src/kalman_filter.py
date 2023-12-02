import numpy as np


class KalmanFilter:
    def __init__(self, initial_state, state_transition, process_noise, measurement_noise, measurement_function):
        self.state = initial_state
        self.state_transition = state_transition
        self.process_noise = process_noise
        self.measurement_noise = measurement_noise
        self.measurement_function = measurement_function
        self.covariance = np.eye(self.state.shape[0])

    def predict(self):
        self.state = np.dot(self.state_transition, self.state)
        self.covariance = np.dot(self.state_transition, np.dot(self.covariance, self.state_transition.T)) + self.process_noise

    def update(self, measurement):
        innovation = measurement - np.dot(self.measurement_function, self.state)
        innovation_covariance = np.dot(self.measurement_function, np.dot(self.covariance, self.measurement_function.T)) + self.measurement_noise
        kalman_gain = np.dot(self.covariance, np.dot(self.measurement_function.T, np.linalg.inv(innovation_covariance)))
        self.state = self.state + np.dot(kalman_gain, innovation)
        self.covariance = self.covariance - np.dot(kalman_gain, np.dot(self.measurement_function, self.covariance))