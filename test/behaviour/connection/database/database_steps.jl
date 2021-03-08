# This file is a part of GraknClient.  License is MIT: https://github.com/Humans-of-Julia/GraknClient.jl/blob/main/LICENSE





#=
from concurrent.futures.thread import ThreadPoolExecutor
from functools import partial
from typing import List

from behave import *
from hamcrest import *

from grakn.common.exception import GraknClientException
from tests.behaviour.config.parameters import parse_list
from tests.behaviour.context import Context
from tests.behaviour.util import assert_collections_equal


def create_databases(context: Context, names: List[str]):
    for name in names:
        context.client.databases().create(name)


@step("connection create database: {database_name}")
def step_impl(context: Context, database_name: str):
    create_databases(context, [database_name])


# TODO: connection create database(s) in other implementations, simplify
@step("connection create databases")
def step_impl(context: Context):
    names = parse_list(context.table)
    create_databases(context, names)


@step("connection create databases in parallel")
def step_impl(context: Context):
    names = parse_list(context.table)
    assert_that(len(names), is_(less_than_or_equal_to(context.THREAD_POOL_SIZE)))
    with ThreadPoolExecutor(max_workers=context.THREAD_POOL_SIZE) as executor:
        for name in names:
            executor.submit(partial(context.client.databases().create, name))


def delete_databases(context: Context, names: List[str]):
    for name in names:
        context.client.databases().get(name).delete()


@step("connection delete database: {name}")
def step_impl(context: Context, name: str):
    delete_databases(context, [name])


@step("connection delete databases")
def step_impl(context: Context):
    delete_databases(context, names=parse_list(context.table))


def delete_databases_throws_exception(context: Context, names: List[str]):
    for name in names:
        try:
            context.client.databases().get(name).delete()
            assert False
        except GraknClientException as e:
            pass


@step("connection delete database; throws exception: {name}")
def step_impl(context: Context, name: str):
    delete_databases_throws_exception(context, [name])


@step("connection delete databases; throws exception")
def step_impl(context: Context):
    delete_databases_throws_exception(context, names=parse_list(context.table))


@step("connection delete databases in parallel")
def step_impl(context: Context):
    names = parse_list(context.table)
    assert_that(len(names), is_(less_than_or_equal_to(context.THREAD_POOL_SIZE)))
    with ThreadPoolExecutor(max_workers=context.THREAD_POOL_SIZE) as executor:
        for name in names:
            executor.submit(partial(context.client.databases().get(name).delete))


def has_databases(context: Context, names: List[str]):
    assert_collections_equal([db.name() for db in context.client.databases().all()], names)


@step("connection has database: {name}")
def step_impl(context: Context, name: str):
    has_databases(context, [name])


@step("connection has databases")
def step_impl(context: Context):
    has_databases(context, names=parse_list(context.table))


def does_not_have_databases(context: Context, names: List[str]):
    databases = [db.name() for db in context.client.databases().all()]
    for name in names:
        assert_that(name, not_(is_in(databases)))


@step("connection does not have database: {name}")
def step_impl(context: Context, name: str):
    does_not_have_databases(context, [name])


@step("connection does not have databases")
def step_impl(context: Context):
    does_not_have_databases(context, names=parse_list(context.table))

=#