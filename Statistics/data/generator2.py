import random
import numpy as np
import matplotlib.pyplot as plt


def f(x):
	return 1.5 ** (x-2) + 2


if __name__ == "__main__":
	x = np.linspace(0, 6, 500)
	y = []

	for i in x:
		y_t = f(i)
		q = 0
		while True:
			q = random.randint(-2, 5)/ random.randint(1, 10)
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