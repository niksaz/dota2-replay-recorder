# Author: Mikita Sazanovich

import sys

sys.path.append('.')

from dotaenv import DotaEnvironment
import pickle
import argparse
import math
import numpy as np

filename = 'replays/1.pickle'


def transform_into_pair(state):
    return state[:83], state[83:]


def record():
    env = DotaEnvironment()

    state = env.reset()
    states = [transform_into_pair(state)]
    done = False
    while not done:
        next_state, reward, done = env.execute(action=0)
        states.append(transform_into_pair(next_state))

    with open(filename, 'wb') as output_file:
        pickle.dump(states, output_file)


def print_out():
    with open(filename, 'rb') as input_file:
        states = pickle.load(input_file)

    for state in states:
        observe, actions = state
        print('observe', observe[[0,1,2,11,12,19,20]])
        print('actions', actions)
    print(len(states))
    return

    cnt = 0
    last_state = np.array([0, 0, 0])
    for state in states:
        if np.all(state == last_state):
            continue
        cnt += 1
        diff = np.array(state[:2]) - np.array(last_state[:2])
        print(state, 'diff is', diff)
        angle_pi = math.atan2(diff[1], diff[0])
        if angle_pi < 0:
            angle_pi += 2 * math.pi
        print(angle_pi / math.pi * 180)
        last_state = state
    print('Overall cnt is', cnt)

def main():

# record()
print_out()
