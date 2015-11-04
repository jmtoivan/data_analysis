#!/usr/bin/env python
#-*- coding: utf-8 -*-

import numpy as np
import matplotlib.pyplot as plt

def main():

	n = 100 # 1000
	beta = 0.2 # 0.4
	steps = 500
	noise_rate = 0.2
	weights = np.ones(n)
	norm_weight_progress = []
	for i in range(0,n):
		norm_weight_progress.append([])
	cum_losses = [0]
	cum_mistake_count = [0]
	for i in range(0,steps):
		sw = sum(weights)
		for j in range(0,n):
			norm_weight_progress[j].append(weights[j]/sw)
		a = np.random.choice([-1,1], size=n, p=[0.5,0.5])
		preds = weights*a
		s = sum(preds)
		if s > 0:
			prediction = 1
		else:
			prediction = -1
		label = np.random.choice([a[0],-a[0]], 1, p=[1-noise_rate, noise_rate])
		#cum_loss = 0
		for i in range(0,len(weights)):
			if label == a[i]:
				continue
			else:
				weights[i] = beta*weights[i]
		if prediction != label:
			cum_losses.append(cum_losses[-1]+1)
		else:
			cum_losses.append(cum_losses[-1])
		
		if prediction != a[0]:
			cum_mistake_count.append(cum_mistake_count[-1]+1)
		else:
			cum_mistake_count.append(cum_mistake_count[-1])
		
	plt.plot(range(0,len(cum_losses)), cum_losses)
	plt.show()
	plt.figure()
	for i in range(0,n):
		plt.plot(range(0,steps), norm_weight_progress[i])
	plt.show()
	plt.figure()
	plt.plot(range(0,len(cum_mistake_count)), cum_mistake_count)
	plt.show()

if __name__ == '__main__':
	main()  