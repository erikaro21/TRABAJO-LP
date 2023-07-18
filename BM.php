<?Php
function badCharHeuristic($str, $size, &$badchar)
{
	for ($i = 0; $i < 256; $i++)
		$badchar[$i] = -1;

	for ($i = 0; $i < $size; $i++)
		$badchar[ord($str[$i])] = $i;
}

function BoyerMoore($str, $pat) {
	$m = strlen($pat);
	$n = strlen($str);
	$i = 0;

	badCharHeuristic($pat, $m, $badchar);

	$s = 0;
	while ($s <= ($n - $m))
	{
		$j = $m - 1;

		while ($j >= 0 && $pat[$j] == $str[$s + $j])
			$j--;

		if ($j < 0)
		{
			$arr[$i++] = $s;
			$s += ($s + $m < $n) ? $m - $badchar[ord($str[$s + $m])] : 1;
		}
		else
			$s += max(1, $j - $badchar[ord($str[$s + $j])]);
	}

	for ($j = 0; $j < $i; $j++)
	{
		$result[$j] = $arr[$j];
	}

	return $result;
}


?>