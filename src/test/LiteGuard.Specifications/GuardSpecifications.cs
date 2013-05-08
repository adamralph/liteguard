// <copyright file="GuardSpecifications.cs" company="LiteGuard contributors">
//  Copyright (c) LiteGuard contributors. All rights reserved.
// </copyright>

namespace LiteGuard.Specifications
{
    using System;
    using FluentAssertions;
    using Xbehave;
    using Xunit;

    public static class GuardSpecifications
    {
        [Scenario]
        public static void NullArgument(string parameterName, object argument, Exception exception)
        {
            "Given a parameter name"
                .Given(() => parameterName = "foo");

            "And a null argument"
                .And(() => argument = null);

            "When guarding against a null argument"
                .When(() => exception = Record.Exception(() => Guard.AgainstNullArgument(parameterName, argument)));

            "Then the exception should be an argument null exception"
                .Then(() => exception.Should().BeOfType<ArgumentNullException>());

            "And the exception message should contain the parameter name and \"null\""
                .And(() => exception.Message.Should().Contain(parameterName).And.Contain("null"));

            "And the exception parameter name should be the parameter name"
                .And(() => exception.As<ArgumentException>().ParamName.Should().Be(parameterName));
        }

        [Scenario]
        public static void NullArgumentProperty(string parameterName, string propertyName, object propertyValue, Exception exception)
        {
            "Given a parameter name"
                .Given(() => parameterName = "foo");

            "And a property name"
                .And(() => propertyName = "Bar");

            "And a null property value"
                .And(() => propertyValue = null);

            "When guarding against a null argument property"
                .When(() => exception = Record.Exception(() => Guard.AgainstNullArgumentProperty(parameterName, propertyName, propertyValue)));

            "Then the exception should be an argument exception"
                .Then(() => exception.Should().BeOfType<ArgumentException>());

            "And the exception message should contain the parameter name, the property name and \"null\""
                .And(() => exception.Message.Should().Contain(parameterName).And.Contain(propertyName).And.Contain("null"));

            "And the exception parameter name should be the parameter name"
                .And(() => exception.As<ArgumentException>().ParamName.Should().Be(parameterName));
        }

        [Scenario]
        public static void NullGenericArgument(string parameterName, object argument, Exception exception)
        {
            "Given a parameter name"
                .Given(() => parameterName = "foo");

            "And a null argument"
                .And(() => argument = null);

            "When guarding against a null argument"
                .When(() => exception = Record.Exception(() => Guard.AgainstNullArgumentIfNullable(parameterName, argument)));

            "Then the exception should be an argument null exception"
                .Then(() => exception.Should().BeOfType<ArgumentNullException>());

            "And the exception message should contain the parameter name and \"null\""
                .And(() => exception.Message.Should().Contain(parameterName).And.Contain("null"));

            "And the exception parameter name should be the parameter name"
                .And(() => exception.As<ArgumentException>().ParamName.Should().Be(parameterName));
        }

        [Scenario]
        public static void NullGenericArgumentProperty(string parameterName, string propertyName, object propertyValue, Exception exception)
        {
            "Given a parameter name"
                .Given(() => parameterName = "foo");

            "And a property name"
                .And(() => propertyName = "Bar");

            "And a null property value"
                .And(() => propertyValue = null);

            "When guarding against a null argument property"
                .When(() => exception = Record.Exception(() => Guard.AgainstNullArgumentPropertyIfNullable(parameterName, propertyName, propertyValue)));

            "Then the exception should be an argument exception"
                .Then(() => exception.Should().BeOfType<ArgumentException>());

            "And the exception message should contain the parameter name, the property name and \"null\""
                .And(() => exception.Message.Should().Contain(parameterName).And.Contain(propertyName).And.Contain("null"));

            "And the exception parameter name should be the parameter name"
                .And(() => exception.As<ArgumentException>().ParamName.Should().Be(parameterName));
        }

        [Scenario]
        public static void NonNullArgument(string parameterName, object argument, Exception exception)
        {
            "Given a parameter name"
                .Given(() => parameterName = "foo");

            "And a non-null argument"
                .And(() => argument = new object());

            "When guarding against a null argument"
                .When(() => exception = Record.Exception(() => Guard.AgainstNullArgument(parameterName, argument)));

            "Then no exception should be thrown"
                .Then(() => exception.Should().BeNull());
        }

        [Scenario]
        public static void NonNullArgumentProperty(string parameterName, string propertyName, object propertyValue, Exception exception)
        {
            "Given a parameter name"
                .Given(() => parameterName = "foo");

            "And a property name"
                .And(() => propertyName = "Bar");

            "And a non-null property value"
                .And(() => propertyValue = new object());

            "When guarding against a null argument property"
                .When(() => exception = Record.Exception(() => Guard.AgainstNullArgumentProperty(parameterName, propertyName, propertyValue)));

            "Then no exception should be thrown"
                .Then(() => exception.Should().BeNull());
        }

        [Scenario]
        [Example("bar")]
        [Example(123)]
        public static void NonNullGenericArgument<TArgument>(TArgument argument, string parameterName, Exception exception)
        {
            "Given a parameter name"
                .Given(() => parameterName = "foo");

            "And an argument of '{0}'"
                .And(() => { });

            "When guarding against a null argument"
                .When(() => exception = Record.Exception(() => Guard.AgainstNullArgumentIfNullable(parameterName, argument)));

            "Then no exception should be thrown"
                .Then(() => exception.Should().BeNull());
        }

        [Scenario]
        [Example("bar")]
        [Example(123)]
        public static void NonNullGenericArgumentProperty<TProperty>(TProperty propertyValue, string parameterName, string propertyName, Exception exception)
        {
            "Given a parameter name"
                .Given(() => parameterName = "foo");

            "And a property name"
                .And(() => propertyName = "Bar");

            "And a non-null property value of '{0}'"
                .And(() => { });

            "When guarding against a null argument property"
                .When(() => exception = Record.Exception(() => Guard.AgainstNullArgumentPropertyIfNullable(parameterName, propertyName, propertyValue)));

            "Then no exception should be thrown"
                .Then(() => exception.Should().BeNull());
        }
    }
}
