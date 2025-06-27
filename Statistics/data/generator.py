import random
import numpy as np
import matplotlib.pyplot as plt


def f(x):
	return (x*1.8 - 3.24) ** 2 + 3


if __name__ == "__main__":
	x = np.linspace(0, 3.6, 500)
	y = []

	for i in x:
		y_t = f(i)
		q = 0
		while True:
			q = random.randint(-100, 50)/random.randint(1, 20)
			if q < 0:
				if y_t + q > 0:
					break
			else:
				if y_t - q > 0:
					break
		y.append(y_t + q)

	with open('data_gen.txt', 'w') as f:
		for v in y:
			f.write(f"{v}\n")
	plt.scatter(x, y, marker='.')
	plt.show()