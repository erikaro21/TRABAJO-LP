<?Php
function fuerzabruta($pattern, $subject) 
{
	$n = strlen($subject);
	$m = strlen($pattern);
 
	for ($i = 0; $i <= $n-$m; $i++) {
		
		for ($j = 0;$j < $m;$j++ ) {
			if($subject[$i+$j]!=$pattern[$j]) 
			break;
		}
		if ($j == $m) 
			return $i;
	}
	return -1;
}


?>