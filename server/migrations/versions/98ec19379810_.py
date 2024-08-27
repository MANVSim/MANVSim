"""empty message

Revision ID: 98ec19379810
Revises: 
Create Date: 2024-08-27 14:42:30.133765

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '98ec19379810'
down_revision = None
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('action',
    sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
    sa.Column('name', sa.String(), nullable=False),
    sa.Column('required_power', sa.Integer(), nullable=False),
    sa.Column('media_refs', sa.JSON(), nullable=True),
    sa.Column('duration_secs', sa.Integer(), nullable=False),
    sa.Column('results', sa.String(), nullable=False),
    sa.PrimaryKeyConstraint('id', name=op.f('pk_action'))
    )
    op.create_table('archived_execution',
    sa.Column('execution_id', sa.Integer(), nullable=False),
    sa.Column('events', sa.JSON(), nullable=False),
    sa.Column('timestamp', sa.Integer(), nullable=False),
    sa.Column('incomplete', sa.Boolean(), nullable=False),
    sa.PrimaryKeyConstraint('execution_id', name=op.f('pk_archived_execution'))
    )
    op.create_table('location',
    sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
    sa.Column('name', sa.String(), nullable=False),
    sa.Column('media_refs', sa.JSON(), nullable=True),
    sa.Column('is_vehicle', sa.Boolean(), nullable=False),
    sa.PrimaryKeyConstraint('id', name=op.f('pk_location'))
    )
    op.create_table('logged_event',
    sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
    sa.Column('execution', sa.Integer(), nullable=False),
    sa.Column('time', sa.Integer(), nullable=False),
    sa.Column('type', sa.String(), nullable=False),
    sa.Column('data', sa.JSON(), nullable=False),
    sa.PrimaryKeyConstraint('id', name=op.f('pk_logged_event'))
    )
    op.create_table('resource',
    sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
    sa.Column('name', sa.String(), nullable=False),
    sa.Column('media_refs', sa.JSON(), nullable=True),
    sa.Column('consumable', sa.Boolean(), nullable=False),
    sa.PrimaryKeyConstraint('id', name=op.f('pk_resource'))
    )
    op.create_table('role',
    sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
    sa.Column('name', sa.String(), nullable=False),
    sa.Column('short_name', sa.String(), nullable=True),
    sa.Column('power', sa.Integer(), nullable=False),
    sa.PrimaryKeyConstraint('id', name=op.f('pk_role'))
    )
    op.create_table('scenario',
    sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
    sa.Column('name', sa.String(), nullable=False),
    sa.PrimaryKeyConstraint('id', name=op.f('pk_scenario'))
    )
    op.create_table('web_user',
    sa.Column('username', sa.String(), nullable=False),
    sa.Column('password', sa.String(), nullable=False),
    sa.Column('role', sa.String(), nullable=False),
    sa.PrimaryKeyConstraint('username', name=op.f('pk_web_user'))
    )
    op.create_table('execution',
    sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
    sa.Column('scenario_id', sa.Integer(), nullable=False),
    sa.Column('name', sa.String(), nullable=False),
    sa.ForeignKeyConstraint(['scenario_id'], ['scenario.id'], name=op.f('fk_execution_scenario_id_scenario')),
    sa.PrimaryKeyConstraint('id', name=op.f('pk_execution'))
    )
    op.create_table('location_contains_location',
    sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
    sa.Column('parent', sa.Integer(), nullable=False),
    sa.Column('child', sa.Integer(), nullable=False),
    sa.ForeignKeyConstraint(['child'], ['location.id'], name=op.f('fk_location_contains_location_child_location')),
    sa.ForeignKeyConstraint(['parent'], ['location.id'], name=op.f('fk_location_contains_location_parent_location')),
    sa.PrimaryKeyConstraint('id', name=op.f('pk_location_contains_location'))
    )
    op.create_table('patient',
    sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
    sa.Column('template_name', sa.String(), nullable=False),
    sa.Column('location', sa.Integer(), nullable=True),
    sa.Column('activity_diagram', sa.JSON(), nullable=False),
    sa.ForeignKeyConstraint(['location'], ['location.id'], name=op.f('fk_patient_location_location')),
    sa.PrimaryKeyConstraint('id', name=op.f('pk_patient'))
    )
    op.create_table('resource_in_location',
    sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
    sa.Column('quantity', sa.Integer(), nullable=False),
    sa.Column('location_id', sa.Integer(), nullable=False),
    sa.Column('resource_id', sa.Integer(), nullable=False),
    sa.ForeignKeyConstraint(['location_id'], ['location.id'], name=op.f('fk_resource_in_location_location_id_location')),
    sa.ForeignKeyConstraint(['resource_id'], ['resource.id'], name=op.f('fk_resource_in_location_resource_id_resource')),
    sa.PrimaryKeyConstraint('id', name=op.f('pk_resource_in_location'))
    )
    op.create_table('resources_needed',
    sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
    sa.Column('action_id', sa.Integer(), nullable=False),
    sa.Column('resource_id', sa.Integer(), nullable=False),
    sa.ForeignKeyConstraint(['action_id'], ['action.id'], name=op.f('fk_resources_needed_action_id_action')),
    sa.ForeignKeyConstraint(['resource_id'], ['resource.id'], name=op.f('fk_resources_needed_resource_id_resource')),
    sa.PrimaryKeyConstraint('id', name=op.f('pk_resources_needed'))
    )
    op.create_table('patient_in_scenario',
    sa.Column('scenario_id', sa.Integer(), nullable=False),
    sa.Column('patient_id', sa.Integer(), nullable=False),
    sa.Column('name', sa.String(), nullable=False),
    sa.ForeignKeyConstraint(['patient_id'], ['patient.id'], name=op.f('fk_patient_in_scenario_patient_id_patient')),
    sa.ForeignKeyConstraint(['scenario_id'], ['scenario.id'], name=op.f('fk_patient_in_scenario_scenario_id_scenario')),
    sa.PrimaryKeyConstraint('scenario_id', 'name', name=op.f('pk_patient_in_scenario'))
    )
    op.create_table('player',
    sa.Column('tan', sa.String(), nullable=False),
    sa.Column('execution_id', sa.Integer(), nullable=False),
    sa.Column('location_id', sa.Integer(), nullable=False),
    sa.Column('role_id', sa.Integer(), nullable=False),
    sa.Column('alerted', sa.Boolean(), nullable=False),
    sa.Column('activation_delay_sec', sa.Integer(), nullable=False),
    sa.ForeignKeyConstraint(['execution_id'], ['execution.id'], name=op.f('fk_player_execution_id_execution')),
    sa.ForeignKeyConstraint(['location_id'], ['location.id'], name=op.f('fk_player_location_id_location')),
    sa.ForeignKeyConstraint(['role_id'], ['role.id'], name=op.f('fk_player_role_id_role')),
    sa.PrimaryKeyConstraint('tan', name=op.f('pk_player'))
    )
    op.create_table('players_to_vehicle_in_execution',
    sa.Column('execution_id', sa.Integer(), nullable=True),
    sa.Column('scenario_id', sa.Integer(), nullable=False),
    sa.Column('player_tan', sa.String(), nullable=True),
    sa.Column('location_id', sa.Integer(), nullable=False),
    sa.Column('vehicle_name', sa.String(), nullable=False),
    sa.ForeignKeyConstraint(['execution_id'], ['execution.id'], name=op.f('fk_players_to_vehicle_in_execution_execution_id_execution')),
    sa.ForeignKeyConstraint(['location_id'], ['location.id'], name=op.f('fk_players_to_vehicle_in_execution_location_id_location')),
    sa.ForeignKeyConstraint(['player_tan'], ['player.tan'], name=op.f('fk_players_to_vehicle_in_execution_player_tan_player')),
    sa.ForeignKeyConstraint(['scenario_id'], ['scenario.id'], name=op.f('fk_players_to_vehicle_in_execution_scenario_id_scenario')),
    sa.PrimaryKeyConstraint('execution_id', 'player_tan', name=op.f('pk_players_to_vehicle_in_execution')),
    sa.UniqueConstraint('execution_id', 'scenario_id', 'vehicle_name', name='unique_execution_vehicle')
    )
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_table('players_to_vehicle_in_execution')
    op.drop_table('player')
    op.drop_table('patient_in_scenario')
    op.drop_table('resources_needed')
    op.drop_table('resource_in_location')
    op.drop_table('patient')
    op.drop_table('location_contains_location')
    op.drop_table('execution')
    op.drop_table('web_user')
    op.drop_table('scenario')
    op.drop_table('role')
    op.drop_table('resource')
    op.drop_table('logged_event')
    op.drop_table('location')
    op.drop_table('archived_execution')
    op.drop_table('action')
    # ### end Alembic commands ###
