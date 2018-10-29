# Author: Mikita Sazanovich

import sys

sys.path.append('.')

from dotaenv import DotaEnvironment
import pickle
import argparse
import os


def transform_into_pair(state):
    return state[:83], state[83:]


def record(filename):
    env = DotaEnvironment()

    state = env.reset()
    states = [transform_into_pair(state)]
    done = False
    while not done:
        next_state, reward, done = env.execute(action=0)
        states.append(transform_into_pair(next_state))

    with open(filename, 'wb') as output_file:
        pickle.dump(states, output_file)


def print_out(filename):
    with open(filename, 'rb') as input_file:
        states = pickle.load(input_file)

    for state in states:
        observe, actions = state
        print('observe', observe[[0, 1, 2, 11, 12, 19, 20]])
        print('actions', actions)
    print(len(states))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('replay_name')
    parser.add_argument('--record', action='store_true', help='Records your actions in the game')
    parser.add_argument('--print', action='store_true', help='Print the recorded actions')
    args = parser.parse_args()

    filename = os.path.join('replays/', args.replay_name)

    if args.record:
        record(filename)
    if args.print:
        print_out(filename)


if __name__ == '__main__':
    main()
