<?php
require_once(dirname(__FILE__).'/config.php');

require_once(dirname(__FILE__).'/User.php');
require_once(dirname(__FILE__).'/Invitation.php');

$errors = array();

$user_exists = false;

if (UserConfig::$enableRegistration && array_key_exists('register', $_POST))
{
	$module = null;

	foreach (UserConfig::$modules as $module)
	{
		if ($module->getID() == $_GET['module']) {
			break;
		}
	}

	if (is_null($module))
	{
		throw new Exception('Wrong module specified');
	}

	$invitation = null;

	if (UserConfig::$enableInvitations)
	{
		if (!array_key_exists('invite', $_GET))
		{
			throw new Exception('Invitation code is not submitted');
		}

		$invitation = Invitation::getByCode($_GET['invite']);

		if (is_null($invitation) || $invitation->getStatus())
		{
			throw new Exception('Invitation code is invalid');
		}
	}

	try
	{
		$remember = false;
		$user = $module->processRegistration($_POST, $remember);

		if (is_null($user))
		{
			header('Location: '.UserConfig::$USERSROOTURL.'/register.php?module='.$_GET['module'].'&error=failed');
			exit;
		}

		if (!is_null($invitation))
		{
			$invitation->setUser($user);
			$invitation->save();
		}

		$user->setSession($remember);

		$return = User::getReturn();
		User::clearReturn();
		if (!is_null($return))
		{
			header('Location: '.$return);
		}
		else
		{
			header('Location: '.UserConfig::$DEFAULTREGISTERRETURN);
		}

		exit;
	}
	catch(InputValidationException $ex)
	{
		$errors[$module->getID()] = $ex->getErrors();
	}
	catch(ExistingUserException $ex)
	{
		$user_exists = true;
		$errors[$module->getID()] = $ex->getErrors();
	}
}

require_once(UserConfig::$header);

?><h1>Sign up</h1>
<div style="background: white; padding: 0 1em"><?php

if (UserConfig::$enableRegistration)
{
	$show_registration_form = true;
	$invitation_used = null;

	if (UserConfig::$enableInvitations)
	{
		if (array_key_exists('invite', $_GET))
		{
			$invitation = Invitation::getByCode($_GET['invite']);

			if (is_null($invitation) || $invitation->getStatus())
			{
				?><p>Invitation code you entered is not valid.</p>
				<form action="" method="GET">
				<input name="invite" size="10" value="<?php echo htmlentities($_GET['invite'])?>"/><input type="submit" value="&gt;&gt;"/>
				</form>
				<?php
				$show_registration_form = false;
			}
			else
			{
				$invitation_used = $invitation;
			}
		}
		else
		{
			?><p><?php echo UserConfig::$invitationRequiredMessage?></p>
			<form action="" method="GET">
			<input name="invite" size="10"/><input type="submit" value="&gt;&gt;"/>
			</form>
			<?php
			$show_registration_form = false;
		}
	}
	
	if ($show_registration_form)
	{
		foreach (UserConfig::$modules as $module)
		{
			$id = $module->getID();

			?>
			<div style="margin-bottom: 2em">
			<h2 name="<?php echo $id?>"><?php echo $module->getTitle()?></h2>
		<?php
			if (array_key_exists($id, $errors) && is_array($errors[$id]) && count($errors[$id]) > 0)
			{
				?><div style="border: 1px solid black; padding: 0.5em; background: #FFFBCF; margin-bottom: 1em; max-width: 25em"><ul><?php
				foreach ($errors[$id] as $field => $errorset)
				{
					foreach ($errorset as $error)
					{
						?><li><?php echo $error?></li><?php
					}
				}
				?></ul></div><?php
			}

			$module->renderRegistrationForm(true, "?module=$id&invite=".(is_null($invitation_used) ? '' : $invitation_used->getCode()), array_key_exists($id, $errors) ? $errors[$id] : array(), $_POST);
			?></div>
<?php
		}
	}
}
else
{
?>
	<p><?php echo UserConfig::$registrationDisabledMessage?></p>

	<p>If you already have an account, you can <a href="<?php echo UserConfig::$USERSROOTURL?>/login.php">log in here</a>.</p>
<?php
}
?></div><?php
require_once(UserConfig::$footer);
