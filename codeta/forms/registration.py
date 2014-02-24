from wtforms import Form, ValidationError, BooleanField, TextField, PasswordField, validators

from codeta import app, db

class RegistrationForm(Form):
    username = TextField('Username', [validators.Length(min=1, max=100)])
    email = TextField('Email Address', [
        validators.Length(min=1, max=100),
        validators.Required(),
        validators.EqualTo('confirm_email', message='Email addresses must match.'),
        validators.Email(message='You must enter a valid email address.')
        ])
    confirm_email = TextField('Repeat email address', [validators.Length(min=3, max=100)])
    password = PasswordField('New Password', [
        validators.Required(),
        validators.EqualTo('confirm_password', message='Passwords must match.'),
        validators.Length(min=9)
        ])
    confirm_password = PasswordField('Repeat Password')
    fname = TextField('First Name', [validators.Length(min=1, max=100)])
    lname = TextField('Last Name', [validators.Length(min=1, max=100)])

    def validate_username(form, field):
        """ make sure the username is not already taken """

        if app.db.get_username(field.data):
            raise ValidationError("Sorry, that username is already taken.")
