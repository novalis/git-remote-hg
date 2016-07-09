CAPABILITY_PUSH=t

test -n "$TEST_DIRECTORY" || TEST_DIRECTORY=$(dirname $0)/
. "$TEST_DIRECTORY"/main.t


# .. and some push mode only specific tests

test_expect_success 'remote delete bookmark' '
	test_when_finished "rm -rf hgrepo* gitrepo*" &&

	(
	hg init hgrepo &&
	cd hgrepo &&
	echo zero > content &&
	hg add content &&
	hg commit -m zero
	hg bookmark feature-a
	) &&

	git clone "hg::hgrepo" gitrepo &&
	check_bookmark hgrepo feature-a zero &&

	(
	cd gitrepo &&
	git push --quiet origin :feature-a
	) &&

	check_bookmark hgrepo feature-a ''
'

test_done
