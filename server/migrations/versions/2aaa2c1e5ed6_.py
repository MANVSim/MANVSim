"""empty message

Revision ID: 2aaa2c1e5ed6
Revises: 985b081ce4e4
Create Date: 2024-07-01 18:30:55.315809

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '2aaa2c1e5ed6'
down_revision = '985b081ce4e4'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('logged_event',
    sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
    sa.Column('execution', sa.String(), nullable=False),
    sa.Column('time', sa.Integer(), nullable=False),
    sa.Column('type', sa.String(), nullable=False),
    sa.Column('data', sa.JSON(), nullable=False),
    sa.PrimaryKeyConstraint('id', name=op.f('pk_logged_event'))
    )
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_table('logged_event')
    # ### end Alembic commands ###